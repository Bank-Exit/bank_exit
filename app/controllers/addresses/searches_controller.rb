module Addresses
  class SearchesController < PublicController
    before_action :set_lookup

    # @route GET /addresses/search (addresses_search)
    def show
      results = Geocoder.search(params[:q], lookup: @lookup)

      @results = case @lookup
                 when :nominatim
                   results.map(&:display_name) || []
                 when :ban_data_gouv_fr
                   results.first ? results.first.data['features'] : []
                 else
                   []
                 end
    end

    private

    def set_lookup
      @lookup = (params[:lookup].presence || :nominatim).to_sym
    end
  end
end
