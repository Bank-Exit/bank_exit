module Merchants
  # This service is responsible to remove soft deleted
  # merchants from database after a determined time.
  class ClearOutdated < ApplicationService
    DELTA_TIME = 14.days

    def call
      outdated_merchants.destroy_all
    end

    private

    def outdated_merchants
      Merchant.deleted.bitcoin_only.where(Merchant.arel_table[:deleted_at].lteq(DELTA_TIME.ago))
    end
  end
end
