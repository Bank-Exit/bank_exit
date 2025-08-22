class MapsController < PublicController
  include Merchandable

  FAQ_CATEGORY = 'map'.freeze

  before_action :set_zoom, :set_latitude, :set_longitude
  before_action :redirect_with_coordinates, if: :missing_coordinates?, only: :index

  after_action :set_seo
  skip_after_action :record_page_view, only: :fetch_markers

  helper_method :from_pagination?

  # @route GET /fr/map {locale: "fr"} (maps_fr)
  # @route GET /es/map {locale: "es"} (maps_es)
  # @route GET /de/map {locale: "de"} (maps_de)
  # @route GET /it/map {locale: "it"} (maps_it)
  # @route GET /en/map {locale: "en"} (maps_en)
  # @route GET /map
  # @route GET /fr/map/:zoom {locale: "fr"}
  # @route GET /es/map/:zoom {locale: "es"}
  # @route GET /de/map/:zoom {locale: "de"}
  # @route GET /it/map/:zoom {locale: "it"}
  # @route GET /en/map/:zoom {locale: "en"}
  # @route GET /map/:zoom
  # @route GET /fr/map/:zoom/:lat {locale: "fr"}
  # @route GET /es/map/:zoom/:lat {locale: "es"}
  # @route GET /de/map/:zoom/:lat {locale: "de"}
  # @route GET /it/map/:zoom/:lat {locale: "it"}
  # @route GET /en/map/:zoom/:lat {locale: "en"}
  # @route GET /map/:zoom/:lat
  # @route GET /fr/map/:zoom/:lat/:lon {locale: "fr"} (pretty_map_fr)
  # @route GET /es/map/:zoom/:lat/:lon {locale: "es"} (pretty_map_es)
  # @route GET /de/map/:zoom/:lat/:lon {locale: "de"} (pretty_map_de)
  # @route GET /it/map/:zoom/:lat/:lon {locale: "it"} (pretty_map_it)
  # @route GET /en/map/:zoom/:lat/:lon {locale: "en"} (pretty_map_en)
  # @route GET /map/:zoom/:lat/:lon
  def index
    session[:map_referer_url] = clean_url(request.url.gsub('&pagy=true', ''))

    if params[:display].present? && params[:display].in?(%w[map table grid])
      session[:merchants_display] = params[:display]
    else
      session[:merchants_display] ||= 'map'
    end

    # Merchant markers are handled by backend to keep code
    # DRY with JavaScript.
    # JSON is used by the `map_controller.js` as data value.
    # @merchants and @merchant_marker are defined in `Merchandable`
    # concern that is shared with other controllers.

    unless from_pagination?
      @all_coins = Coin.all(decorate: true)
      @last_update = last_update.to_i

      @faqs = FAQ.all.select do |faq|
        FAQ_CATEGORY.in?(faq.categories)
      end

      @directory_friends = DirectoryFriend.all

      set_meta_tags canonical: pretty_map_url(
        zoom: Setting::MAP_DEFAULT_ZOOM,
        lat: Setting::MAP_DEFAULT_LATITUDE,
        lon: Setting::MAP_DEFAULT_LONGITUDE
      )
    end

    @pagy, page_ids = pagy_array(
      merchant_ids.ids, params: ->(params) { params.compact_blank.merge!(pagy: true) }
    )

    merchants = Merchant.where(id: page_ids).in_order_of(:id, page_ids)

    @merchants = MerchantDecorator.wrap(merchants)

    render variants: [
      session[:merchants_display].to_sym
    ]
  end

  # @route GET /fr/map/fetch_markers {locale: "fr"} (map_fetch_markers_fr)
  # @route GET /es/map/fetch_markers {locale: "es"} (map_fetch_markers_es)
  # @route GET /de/map/fetch_markers {locale: "de"} (map_fetch_markers_de)
  # @route GET /it/map/fetch_markers {locale: "it"} (map_fetch_markers_it)
  # @route GET /en/map/fetch_markers {locale: "en"} (map_fetch_markers_en)
  # @route GET /map/fetch_markers
  def fetch_markers
    render json: merchants_markers
  end

  private

  def map_params
    params.permit(
      :search, :category, :country, :continent,
      :delivery, :no_kyc, :order_by_survey,
      :locale, :pagy, :page, :zoom, :lat, :lon,
      :display, coins: []
    )
  end

  def query
    @query ||= map_params[:search]
  end

  def coins
    @coins ||= map_params[:coins] || []
  end

  def category
    @category ||= map_params[:category]
  end

  def country
    @country ||= map_params[:country]
  end

  def continent
    @continent ||= map_params[:continent]
  end

  def delivery?
    map_params[:delivery] == '1'
  end

  def no_kyc?
    map_params[:no_kyc] == '1'
  end

  def order_by_survey?
    map_params[:order_by_survey] == '1'
  end

  def set_zoom
    @zoom = map_params[:zoom]
  end

  def set_latitude
    @latitude = map_params[:lat]
  end

  def set_longitude
    @longitude = map_params[:lon]
  end

  def last_update
    File.read('storage/last_fetch_at.txt')
  rescue Errno::ENOENT
    nil
  end

  def from_pagination?
    params[:pagy]
  end

  def set_seo
    image = view_context.image_url('projects/map_monero.jpg')

    set_meta_tags og: { image: image },
                  twitter: { image: image }
  end

  def redirect_with_coordinates
    redirect_to pretty_map_path(
      zoom: @zoom || Setting::MAP_DEFAULT_ZOOM,
      lat: @latitude || Setting::MAP_DEFAULT_LATITUDE,
      lon: @longitude || Setting::MAP_DEFAULT_LONGITUDE,
      params: request.query_parameters
    )
  end

  def missing_coordinates?
    params[:lat].blank? || params[:lon].blank? || params[:zoom].blank?
  end
end
