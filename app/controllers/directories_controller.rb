class DirectoriesController < ApplicationController
  before_action :set_directory, only: :show
  before_action :set_faqs, only: %i[index new show]

  helper_method :around_me?

  add_breadcrumb proc { I18n.t('application.nav.menu.home') }, :root_path
  add_breadcrumb proc { Directory.model_name.human.capitalize }, :directories_referer_path

  # @route GET /fr/directories {locale: "fr"} (directories_fr)
  # @route GET /es/directories {locale: "es"} (directories_es)
  # @route GET /de/directories {locale: "de"} (directories_de)
  # @route GET /it/directories {locale: "it"} (directories_it)
  # @route GET /en/directories {locale: "en"} (directories_en)
  # @route GET /directories
  def index
    session[:directories_referer_url] = clean_url(request.url)
    if params[:presentation].present?
      session[:directories_presentation] = params[:presentation]
    else
      session[:directories_presentation] ||= 'grid'
    end

    directories_filter = Directories::Filter.new(**filter_params, ip: request.remote_ip)
    directories = directories_filter.call

    @my_geocoder = directories_filter.geocoder_ip if around_me?

    @spotlights = Directory.enabled.spotlights.by_position.includes(:logo_attachment)

    directories = DirectoryDecorator.wrap(directories.uniq)

    @pagy, @directories = pagy_array(directories)

    set_meta_tags canonical: directories_url

    respond_to do |format|
      format.html
      format.turbo_stream if filter_params.present? || params[:page].present?
    end
  end

  # @route GET /fr/directories/new {locale: "fr"} (new_directory_fr)
  # @route GET /es/directories/new {locale: "es"} (new_directory_es)
  # @route GET /de/directories/new {locale: "de"} (new_directory_de)
  # @route GET /it/directories/new {locale: "it"} (new_directory_it)
  # @route GET /en/directories/new {locale: "en"} (new_directory_en)
  # @route GET /directories/new
  def new
    add_breadcrumb t('.title')

    @directory = Directory.new(from_proposition: true)
    @directory.build_address
  end

  # @route POST /fr/directories {locale: "fr"} (directories_fr)
  # @route POST /es/directories {locale: "es"} (directories_es)
  # @route POST /de/directories {locale: "de"} (directories_de)
  # @route POST /it/directories {locale: "it"} (directories_it)
  # @route POST /en/directories {locale: "en"} (directories_en)
  # @route POST /directories
  def create
    @directory = Directory.new(directory_params) do |directory|
      directory.from_proposition = true
      directory.enabled = false
    end

    if @directory.save
      redirect_to directories_path, notice: t('.notice')
    else
      add_breadcrumb t('directories.new.title')
      set_faqs

      @directory.build_address if @directory.address.blank?

      render :new, status: :unprocessable_entity
    end
  end

  # @route GET /fr/directories/:id {locale: "fr"} (directory_fr)
  # @route GET /es/directories/:id {locale: "es"} (directory_es)
  # @route GET /de/directories/:id {locale: "de"} (directory_de)
  # @route GET /it/directories/:id {locale: "it"} (directory_it)
  # @route GET /en/directories/:id {locale: "en"} (directory_en)
  # @route GET /directories/:id
  def show
    add_breadcrumb @directory.name

    set_meta_tags title: @directory.name,
                  description: @directory.description
  end

  private

  def set_directory
    @directory = Directory.enabled.find(params[:id]).decorate
  end

  def directory_params
    params.expect(
      directory: [
        :name, :description,
        :logo, :banner, :category,
        {
          address_attributes: %i[id label],
          coin_wallets_attributes: [%i[
            id coin public_address _destroy
          ]],
          delivery_zones_attributes: [%i[
            id mode value _destroy
          ]],
          contact_ways_attributes: [%i[
            id role value _destroy
          ]],
          weblinks_attributes: [%i[
            id url title _destroy
          ]]
        }
      ]
    )
  end

  def filter_params
    params.permit([
                    :around_me, :query, :category, :city, :postcode,
                    :department, :region, :country,
                    :continent, :world, :presentation,
                    { coins: [] }
                  ])
  end

  def around_me?
    filter_params[:around_me] == '1'
  end

  def set_faqs
    @faqs = FAQ.all.select do |faq|
      'directory'.in?(faq.categories)
    end
  end
end
