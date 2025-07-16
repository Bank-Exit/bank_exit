module Maps
  class ReferersController < ApplicationController
    skip_after_action :record_page_view

    # @route PATCH /maps/referer (maps_referer)
    # @route PUT /maps/referer (maps_referer)
    def update
      session[:map_referer_url] = params[:map_referer_url]

      head :ok
    end
  end
end
