class MerchantsController < PublicController
  before_action :set_merchant, only: :show

  include Commentable if -> { comments_enabled? }

  add_breadcrumb proc { I18n.t('application.nav.menu.home') }, :root_path
  add_breadcrumb proc { I18n.t('application.nav.menu.map') }, :map_referer_path

  # @route GET /fr/merchants/:id {locale: "fr"} (merchant_fr)
  # @route GET /es/merchants/:id {locale: "es"} (merchant_es)
  # @route GET /de/merchants/:id {locale: "de"} (merchant_de)
  # @route GET /it/merchants/:id {locale: "it"} (merchant_it)
  # @route GET /en/merchants/:id {locale: "en"} (merchant_en)
  # @route GET /merchants/:id
  def show
    @faqs = FAQ.all.select do |faq|
      faq.categories.include?('merchant')
    end

    add_breadcrumb @merchant.name

    set_meta_tags title: @merchant.name,
                  description: @merchant.description

    # Render adapted `show.html+banner` template if
    # merchant has an attached banner to highlight.
    request.variant = :banner if @merchant.banner.attached?
  end

  # @route POST /fr/merchants/refresh {locale: "fr"} (refresh_merchants_fr)
  # @route POST /es/merchants/refresh {locale: "es"} (refresh_merchants_es)
  # @route POST /de/merchants/refresh {locale: "de"} (refresh_merchants_de)
  # @route POST /it/merchants/refresh {locale: "it"} (refresh_merchants_it)
  # @route POST /en/merchants/refresh {locale: "en"} (refresh_merchants_en)
  # @route POST /merchants/refresh
  def refresh
    respond_to do |format|
      format.turbo_stream do
        FetchMerchants.call_later
        flash.now[:notice] = t('.notice')
      end
    end
  end

  private

  def set_merchant
    @merchant = Merchant.find_by!(identifier: merchant_id).decorate

    if @merchant.deleted? && !debug_mode?
      flash[:alert] = t('.alert')
      redirect_to maps_path, status: :found
    end
  rescue ActiveRecord::RecordNotFound
    # Indicates to search engines that some already referenced
    # merchants URLs have been removed by using a permanent
    # redirection to the map page.
    redirect_to maps_path, status: :moved_permanently
  end

  def merchant_id
    params[:id].split('-').first
  end

  def debug_mode?
    params[:debug] == 'true'
  end

  def commentable
    @merchant
  end
end
