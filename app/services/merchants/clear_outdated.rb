module Merchants
  # This service is responsible to remove soft deleted
  # merchants from database after a determined time.
  class ClearOutdated < ApplicationService
    DELTA_TIME = 14.days

    attr_reader :instigator

    def initialize(instigator = :task)
      @instigator = instigator
      @logs = []
    end

    def call
      @logs << { mode: 'info', message: 'Retrieving outdated merchants', timestamp: Time.current.to_i }

      @merchant_sync = MerchantSync.create!(
        mode: :clear,
        status: :pending,
        instigator: instigator,
        started_at: Time.current,
        process_logs: @logs
      )

      soft_deleted_merchants_count = outdated_merchants.count
      payload_soft_deleted_merchants = outdated_merchants.map(&:raw_feature)

      @logs << { mode: 'info', message: 'Removing outdated merchants', timestamp: Time.current.to_i }
      @merchant_sync.update!(process_logs: @logs)

      outdated_merchants.destroy_all

      @logs << { mode: 'success', message: 'Outdated merchants removed successfully ! ', timestamp: Time.current.to_i }

      @merchant_sync.update!(
        status: :success,
        ended_at: Time.current,
        soft_deleted_merchants_count: soft_deleted_merchants_count,
        payload_soft_deleted_merchants: payload_soft_deleted_merchants,
        process_logs: @logs
      )
    rescue StandardError => e
      @logs << { mode: 'error', message: "💥 #{e.message}", timestamp: Time.current.to_i }

      @merchant_sync.update!(
        status: :error,
        ended_at: Time.current,
        process_logs: @logs,
        payload_error: {
          exception: e.class.name,
          message: e.message,
          backtrace: e.backtrace
        }
      )
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
