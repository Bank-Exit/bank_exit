module Merchants
  class AssignCountry < ApplicationService
    attr_reader :payload_countries

    def initialize(initial_scope = nil)
      @initial_scope = initial_scope
      @payload_countries = []
    end

    def call
      merchants.find_in_batches(batch_size: 300) do |group|
        @updated_merchants = []

        group.each do |merchant|
          latitude = merchant.latitude
          longitude = merchant.longitude

          next unless latitude && longitude

          results = Geocoder.search([latitude, longitude])

          result = results.first
          country = result&.country
          country_code = result&.country_code&.upcase

          next unless country_code

          # Use accurate French DOM/TOM country code
          # instead of the main country
          country_code = handle_country_state(result.state) || country_code

          # Extra patching for islands, municipalities
          # and territories not properly handled by
          # Geocoder
          country_code = 'AW' if country == 'Aruba'
          country_code = 'CW' if country == 'Curacao'
          country_code = 'SX' if country == 'Sint Maarten'
          # Bonaire, Sint Eustatius and Saba
          country_code = 'BQ' if result.data.dig('address', 'ISO3166-2-lvl8')

          # Assign corresponding continent for the
          # identified `country_code`.
          continent_code = COUNTRY_TO_CONTINENT[country_code]

          @updated_merchants << {
            id: merchant.id,
            osm_id: merchant.identifier,
            name: merchant.name,
            country: country_code,
            country_full_name: country,
            continent_code: continent_code
          }
        end

        if @updated_merchants.present?
          data = @updated_merchants.map { it.slice(:id, :country, :continent_code) }

          Merchant.upsert_all(data, unique_by: :id)

          payload_countries << data
        end
      end

      payload_countries.flatten
    end

    private

    def merchants
      @merchants ||= @initial_scope || Merchant.where(country: nil)
    end

    def handle_country_state(state)
      {
        'French Polynesia' => 'PF',
        'Guadeloupe' => 'GP',
        'Martinique' => 'MQ',
        'Reunion' => 'RE',
        'Mayotte' => 'YT',
        'Guam' => 'GU',
        'Puerto Rico' => 'PR'
      }[state]
    end
  end
end
