module Admin
  class DirectoriesController < BaseController
    before_action :set_directory, only: %i[
      edit update destroy update_position
    ]

    # @route GET /fr/admin/directories {locale: "fr"} (admin_directories_fr)
    # @route GET /es/admin/directories {locale: "es"} (admin_directories_es)
    # @route GET /de/admin/directories {locale: "de"} (admin_directories_de)
    # @route GET /it/admin/directories {locale: "it"} (admin_directories_it)
    # @route GET /en/admin/directories {locale: "en"} (admin_directories_en)
    # @route GET /admin/directories
    def index
      authorize!

      directories = Directory.includes(:address, :coin_wallets, :contact_ways, :logo_attachment).by_position
      directories = directories.by_query(query) if query
      @directories = DirectoryDecorator.wrap(directories)
    end

    # @route GET /fr/admin/directories/new {locale: "fr"} (new_admin_directory_fr)
    # @route GET /es/admin/directories/new {locale: "es"} (new_admin_directory_es)
    # @route GET /de/admin/directories/new {locale: "de"} (new_admin_directory_de)
    # @route GET /it/admin/directories/new {locale: "it"} (new_admin_directory_it)
    # @route GET /en/admin/directories/new {locale: "en"} (new_admin_directory_en)
    # @route GET /admin/directories/new
    def new
      authorize!

      @directory = Directory.new
      @directory.build_address
    end

    # @route POST /fr/admin/directories {locale: "fr"} (admin_directories_fr)
    # @route POST /es/admin/directories {locale: "es"} (admin_directories_es)
    # @route POST /de/admin/directories {locale: "de"} (admin_directories_de)
    # @route POST /it/admin/directories {locale: "it"} (admin_directories_it)
    # @route POST /en/admin/directories {locale: "en"} (admin_directories_en)
    # @route POST /admin/directories
    def create
      authorize!

      @directory = Directory.new(directory_params)

      if @directory.save
        flash[:notice] = t('.notice')

        redirect_to admin_directories_path
      else
        @directory.build_address if @directory.address.blank?

        render :new, status: :unprocessable_content
      end
    end

    # @route GET /fr/admin/directories/:id/edit {locale: "fr"} (edit_admin_directory_fr)
    # @route GET /es/admin/directories/:id/edit {locale: "es"} (edit_admin_directory_es)
    # @route GET /de/admin/directories/:id/edit {locale: "de"} (edit_admin_directory_de)
    # @route GET /it/admin/directories/:id/edit {locale: "it"} (edit_admin_directory_it)
    # @route GET /en/admin/directories/:id/edit {locale: "en"} (edit_admin_directory_en)
    # @route GET /admin/directories/:id/edit
    def edit
      authorize! @directory

      @directory.build_address if @directory.address.blank?
    end

    # @route PATCH /fr/admin/directories/:id {locale: "fr"} (admin_directory_fr)
    # @route PATCH /es/admin/directories/:id {locale: "es"} (admin_directory_es)
    # @route PATCH /de/admin/directories/:id {locale: "de"} (admin_directory_de)
    # @route PATCH /it/admin/directories/:id {locale: "it"} (admin_directory_it)
    # @route PATCH /en/admin/directories/:id {locale: "en"} (admin_directory_en)
    # @route PATCH /admin/directories/:id
    # @route PUT /fr/admin/directories/:id {locale: "fr"} (admin_directory_fr)
    # @route PUT /es/admin/directories/:id {locale: "es"} (admin_directory_es)
    # @route PUT /de/admin/directories/:id {locale: "de"} (admin_directory_de)
    # @route PUT /it/admin/directories/:id {locale: "it"} (admin_directory_it)
    # @route PUT /en/admin/directories/:id {locale: "en"} (admin_directory_en)
    # @route PUT /admin/directories/:id
    def update
      authorize! @directory

      if @directory.update(directory_params)
        flash[:notice] = t('.notice')

        redirect_to admin_directories_path
      else
        @directory.build_address if @directory.address.blank?

        render :edit, status: :unprocessable_content
      end
    end

    # @route DELETE /fr/admin/directories/:id {locale: "fr"} (admin_directory_fr)
    # @route DELETE /es/admin/directories/:id {locale: "es"} (admin_directory_es)
    # @route DELETE /de/admin/directories/:id {locale: "de"} (admin_directory_de)
    # @route DELETE /it/admin/directories/:id {locale: "it"} (admin_directory_it)
    # @route DELETE /en/admin/directories/:id {locale: "en"} (admin_directory_en)
    # @route DELETE /admin/directories/:id
    def destroy
      authorize! @directory

      @directory.destroy

      flash[:notice] = t('.notice')

      redirect_to admin_directories_path
    end

    # @route PATCH /fr/admin/directories/:id/update_position {locale: "fr"} (update_position_admin_directory_fr)
    # @route PATCH /es/admin/directories/:id/update_position {locale: "es"} (update_position_admin_directory_es)
    # @route PATCH /de/admin/directories/:id/update_position {locale: "de"} (update_position_admin_directory_de)
    # @route PATCH /it/admin/directories/:id/update_position {locale: "it"} (update_position_admin_directory_it)
    # @route PATCH /en/admin/directories/:id/update_position {locale: "en"} (update_position_admin_directory_en)
    # @route PATCH /admin/directories/:id/update_position
    def update_position
      authorize! @directory

      if @directory.update(directory_params.slice(:position))
        directories = Directory.by_position.includes(:logo_attachment, :address, :coin_wallets, :contact_ways)
        @directories = DirectoryDecorator.wrap(directories)
      else
        head :unprocessable_content
      end
    end

    private

    def directory_params
      translated_params = I18n.available_locales.map do |l|
        [
          :"name_#{Mobility.normalize_locale(l)}",
          :"description_#{Mobility.normalize_locale(l)}"
        ]
      end.flatten

      params.expect(directory: [
        :position, :enabled, :spotlight,
        :logo, :banner, :category,
        :remove_logo, :remove_banner,
        {
          address_attributes: %i[id label],
          coin_wallets_attributes: [%i[
            id coin public_address enabled _destroy
          ]],
          delivery_zones_attributes: [%i[
            id mode value enabled _destroy
          ]],
          contact_ways_attributes: [%i[
            id role value enabled _destroy
          ]],
          weblinks_attributes: [%i[
            id url title enabled _destroy
          ]]
        }
      ].push(translated_params))
    end

    def set_directory
      @directory = Directory.find(params[:id])
    end

    def query
      @query ||= params[:query]
    end
  end
end
