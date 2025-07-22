module Merchants
  class ItinerariesController < PublicController
    before_action :set_merchant

    # @route GET /fr/merchants/:merchant_id/itinerary/new {locale: "fr"} (new_merchant_itinerary_fr)
    # @route GET /es/merchants/:merchant_id/itinerary/new {locale: "es"} (new_merchant_itinerary_es)
    # @route GET /de/merchants/:merchant_id/itinerary/new {locale: "de"} (new_merchant_itinerary_de)
    # @route GET /it/merchants/:merchant_id/itinerary/new {locale: "it"} (new_merchant_itinerary_it)
    # @route GET /en/merchants/:merchant_id/itinerary/new {locale: "en"} (new_merchant_itinerary_en)
    # @route GET /merchants/:merchant_id/itinerary/new
    def new
    end

    # @route POST /fr/merchants/:merchant_id/itinerary {locale: "fr"} (merchant_itinerary_fr)
    # @route POST /es/merchants/:merchant_id/itinerary {locale: "es"} (merchant_itinerary_es)
    # @route POST /de/merchants/:merchant_id/itinerary {locale: "de"} (merchant_itinerary_de)
    # @route POST /it/merchants/:merchant_id/itinerary {locale: "it"} (merchant_itinerary_it)
    # @route POST /en/merchants/:merchant_id/itinerary {locale: "en"} (merchant_itinerary_en)
    # @route POST /merchants/:merchant_id/itinerary
    def create
      if search_by_ip?
        results = Geocoder.search(request.remote_ip)
      else
        my_address = params.dig(:itinerary, :my_address)
        results = Geocoder.search(my_address)
      end

      @no_results = results.blank?
      return if @no_results

      @my_lat, @my_lon = results.first.coordinates

      @routing = OSRMRouterAPI.new.calculate_itinerary(
        @my_lat, @my_lon, @merchant.latitude, @merchant.longitude,
        detailed_steps: detailed_steps?
      )

      if @routing.success?
        @route = @routing['routes'].first
        @start_address = @routing['waypoints'].first['name']
      else
        @no_results = true
      end
    end

    private

    def set_merchant
      @merchant = Merchant.find_by!(identifier: merchant_id).decorate
    end

    def merchant_id
      params[:merchant_id].split('-').first
    end

    def search_by_ip?
      params.dig(:itinerary, :use_my_ip) == '1'
    end

    def detailed_steps?
      @detailed_steps = params.dig(:itinerary, :detailed_steps) == '1'
    end
  end
end
