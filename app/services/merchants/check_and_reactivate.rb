module Merchants
  # Bring back to life merchants that have been enabled
  # back on OpenStreetMap after being marked as deleted.
  class CheckAndReactivate < ApplicationService
    attr_reader :geojson_merchant_ids

    def initialize(geojson_merchant_ids)
      @geojson_merchant_ids = geojson_merchant_ids
    end

    def call
      scope = Merchant.deleted.where(original_identifier: geojson_merchant_ids)

      scope_osm_ids = scope.pluck(:original_identifier)

      scope.update_all(deleted_at: nil)

      Rails.logger.debug { "Merchants reactivated (OSM identifier): #{scope_osm_ids}" }
    end
  end
end
