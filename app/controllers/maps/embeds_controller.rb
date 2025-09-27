module Maps
  class EmbedsController < ApplicationController
    content_security_policy do |policy|
      policy.frame_ancestors '*'
    end

    include Localizable
    include Analyticable
    include Merchandable

    before_action :set_options
    after_action :remove_frame_header

    attr_reader :country, :continent, :coins

    layout 'minimal'

    # @route GET /fr/map/embed {locale: "fr"} (maps_embed_fr)
    # @route GET /es/map/embed {locale: "es"} (maps_embed_es)
    # @route GET /de/map/embed {locale: "de"} (maps_embed_de)
    # @route GET /it/map/embed {locale: "it"} (maps_embed_it)
    # @route GET /en/map/embed {locale: "en"} (maps_embed_en)
    # @route GET /map/embed (map_embed)
    def show
    end

    private

    def set_options
      @theme = {
        light: Setting::LIGHT_THEME_NAME,
        dark: Setting::DARK_THEME_NAME
      }[params[:theme]&.to_sym] || Setting::MAP_DEFAULT_THEME

      @latitude = params[:latitude]
      @longitude = params[:longitude]
      @zoom = params[:zoom]

      @continent = params[:continent]
      @country = params[:country] unless @continent

      @coins = params[:coins].presence || []

      @gesture_handling = params[:gestureHandling] != 'false'
      @fit_bounds = params[:fitBounds] == 'true'
      @use_clusters = params[:clusters] != 'false'
      @show_attribution = params[:attribution] != 'false'
    end

    # Remove default Rails header to allow map embedding
    # @see https://guides.rubyonrails.org/security.html#configuring-the-default-headers
    def remove_frame_header
      response.header.delete('X-Frame-Options')
    end
  end
end
