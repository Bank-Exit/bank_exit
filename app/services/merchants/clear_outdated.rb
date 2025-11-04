module Merchants
  # This service is responsible to remove soft deleted
  # merchants from database after a determined time.
  class ClearOutdated < ApplicationService
    DELTA_TIME = 14.days

    attr_reader :instigator

    def initialize(instigator = :task)
      @instigator = instigator
    end

    def call
      soft_deleted_merchants_count = outdated_merchants.count
      payload_soft_deleted_merchants = outdated_merchants.map(&:raw_feature)

      @merchant_sync = MerchantSync.create!(
        mode: :clear,
        status: :pending,
        instigator: instigator,
        started_at: Time.current
      )

      outdated_merchants.destroy_all

      @merchant_sync.update!(
        status: :success,
        ended_at: Time.current,
        soft_deleted_merchants_count: soft_deleted_merchants_count,
        payload_soft_deleted_merchants: payload_soft_deleted_merchants
      )
    rescue StandardError => e
      @merchant_sync.update!(
        status: :error,
        ended_at: Time.current,
        payload_error: {
          exception: e.class.name,
          message: e.message,
          backtrace: e.backtrace
        }
      )
    end

    private

    def outdated_merchants
      Merchant.deleted.bitcoin_only.where(Merchant.arel_table[:deleted_at].lteq(DELTA_TIME.ago))
    end
  end
end
