module Admin
  class DirectoriesController < BaseController
    before_action :set_directory, only: %i[
      edit update destroy update_position
    ]

    # @route GET /admin/directories (admin_directories)
    def index
      authorize!

      directories = Directory.includes(:address, :coin_wallets, :contact_ways, :logo_attachment).by_position
      directories = directories.by_query(query) if query
      @directories = DirectoryDecorator.wrap(directories)

      set_meta_tags title: "L'annuaire"
    end

    # @route GET /admin/directories/new (new_admin_directory)
    def new
      authorize!

      @directory = Directory.new
      @directory.build_address

      set_meta_tags title: "Ajouter une entrée à l'annuaire"
    end

    # @route POST /admin/directories (admin_directories)
    def create
      authorize!

      @directory = Directory.new(directory_params)

      if @directory.save
        flash[:notice] = "L'entrée a bien été ajoutée à l'annuaire"

        redirect_to admin_directories_path
      else
        @directory.build_address if @directory.address.blank?

        render :new, status: :unprocessable_entity
      end
    end

    # @route GET /admin/directories/:id/edit (edit_admin_directory)
    def edit
      authorize! @directory

      @directory.build_address if @directory.address.blank?
    end

    # @route PATCH /admin/directories/:id (admin_directory)
    # @route PUT /admin/directories/:id (admin_directory)
    def update
      authorize! @directory

      if @directory.update(directory_params)
        flash[:notice] = "L'entrée de l'annuaire a bien été modifiée"

        redirect_to admin_directories_path
      else
        @directory.build_address if @directory.address.blank?

        render :edit, status: :unprocessable_entity
      end
    end

    # @route DELETE /admin/directories/:id (admin_directory)
    def destroy
      authorize! @directory

      @directory.destroy

      flash[:notice] = "L'entrée de l'annuaire a bien été supprimée"

      redirect_to admin_directories_path
    end

    # @route PATCH /admin/directories/:id/update_position (update_position_admin_directory)
    def update_position
      authorize! @directory

      if @directory.update(directory_params.slice(:position))
        directories = Directory.by_position.includes(:logo_attachment, :address, :coin_wallets, :contact_ways)
        @directories = DirectoryDecorator.wrap(directories)
      else
        head :unprocessable_entity
      end
    end

    private

    def directory_params
      params.expect(directory: [
                      :name, :description, :position, :enabled, :spotlight,
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
                    ])
    end

    def set_directory
      @directory = Directory.find(params[:id])
    end

    def query
      @query ||= params[:query]
    end
  end
end
