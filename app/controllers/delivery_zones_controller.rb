class DeliveryZonesController < PublicController
  include DeliveryZonesHelper

  # @route GET /fr/delivery_zones/mode_values {locale: "fr"} (mode_values_delivery_zones_fr)
  # @route GET /es/delivery_zones/mode_values {locale: "es"} (mode_values_delivery_zones_es)
  # @route GET /de/delivery_zones/mode_values {locale: "de"} (mode_values_delivery_zones_de)
  # @route GET /it/delivery_zones/mode_values {locale: "it"} (mode_values_delivery_zones_it)
  # @route GET /en/delivery_zones/mode_values {locale: "en"} (mode_values_delivery_zones_en)
  # @route GET /delivery_zones/mode_values
  def mode_values
    @target = params[:target]
    @mode = params[:mode]
    @name = params[:name].gsub('[mode]', '[value]')

    @data = case @mode
            when 'region'
              french_regions_select_helper
            when 'department'
              french_departments_select_helper
            when 'continent'
              continents_select_helper
            end

    respond_to do |format|
      format.turbo_stream
    end
  end
end
