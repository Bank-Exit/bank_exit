module Merchants
  # This service is responsible to remove soft deleted
  # merchants from database after a determined time.
  class ClearOutdated < ApplicationService
    DELTA_TIME = 14.days

    attr_reader :instigator

    def initialize(instigator = :task)
      @instigator = instigator
    end

    def prepare
      @merchant_sync = MerchantSync.create!(
        mode: :clear,
        status: :pending,
        instigator: instigator,
        started_at: Time.current
      )

      @merchant_sync.merchant_sync_steps.create!(step: :init_clear, status: :success)
    end

    def call
      fetch_step = @merchant_sync.merchant_sync_steps.create!(step: :fetch_outdated)

      soft_deleted_merchants_count = outdated_merchants.count
      payload_soft_deleted_merchants = outdated_merchants.map(&:raw_feature)

      fetch_step.success!

      clearing_step = @merchant_sync.merchant_sync_steps.create!(step: :clear_outdated)

      begin
        outdated_merchants.destroy_all
        clearing_step.success!
      rescue StandardError => e
        clearing_step.mark_as_fail(e)
        raise e
      end

      @merchant_sync.merchant_sync_steps.create!(step: :end_of_clear, status: :success)

      @merchant_sync.update!(
        status: :success,
        ended_at: Time.current,
        soft_deleted_merchants_count: soft_deleted_merchants_count,
        payload_soft_deleted_merchants: payload_soft_deleted_merchants
      )
    rescue StandardError => _e
      @merchant_sync.mark_as_fail!
    end

    private

    def outdated_merchants
      @outdated_merchants ||=
        Merchant
        .deleted
        .bitcoin_only
        .where(Merchant.arel_table[:deleted_at].lteq(DELTA_TIME.ago))
    end
  end
end
