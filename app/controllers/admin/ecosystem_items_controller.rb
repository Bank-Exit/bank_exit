module Admin
  class EcosystemItemsController < BaseController
    before_action :set_ecosystem_item, only: %i[
      edit update destroy
    ]

    # @route GET /fr/admin/ecosystem_items {locale: "fr"} (admin_ecosystem_items_fr)
    # @route GET /es/admin/ecosystem_items {locale: "es"} (admin_ecosystem_items_es)
    # @route GET /de/admin/ecosystem_items {locale: "de"} (admin_ecosystem_items_de)
    # @route GET /it/admin/ecosystem_items {locale: "it"} (admin_ecosystem_items_it)
    # @route GET /en/admin/ecosystem_items {locale: "en"} (admin_ecosystem_items_en)
    # @route GET /admin/ecosystem_items
    def index
      authorize!

      @pagy, @ecosystem_items = pagy(EcosystemItem.all)
    end

    # @route GET /fr/admin/ecosystem_items/new {locale: "fr"} (new_admin_ecosystem_item_fr)
    # @route GET /es/admin/ecosystem_items/new {locale: "es"} (new_admin_ecosystem_item_es)
    # @route GET /de/admin/ecosystem_items/new {locale: "de"} (new_admin_ecosystem_item_de)
    # @route GET /it/admin/ecosystem_items/new {locale: "it"} (new_admin_ecosystem_item_it)
    # @route GET /en/admin/ecosystem_items/new {locale: "en"} (new_admin_ecosystem_item_en)
    # @route GET /admin/ecosystem_items/new
    def new
      authorize!

      @ecosystem_item = EcosystemItem.new
    end

    # @route POST /fr/admin/ecosystem_items {locale: "fr"} (admin_ecosystem_items_fr)
    # @route POST /es/admin/ecosystem_items {locale: "es"} (admin_ecosystem_items_es)
    # @route POST /de/admin/ecosystem_items {locale: "de"} (admin_ecosystem_items_de)
    # @route POST /it/admin/ecosystem_items {locale: "it"} (admin_ecosystem_items_it)
    # @route POST /en/admin/ecosystem_items {locale: "en"} (admin_ecosystem_items_en)
    # @route POST /admin/ecosystem_items
    def create
      authorize!

      @ecosystem_item = EcosystemItem.new(ecosystem_item_params)

      if @ecosystem_item.save
        flash[:notice] = t('.notice')

        redirect_to admin_ecosystem_items_path
      else
        render :new, status: :unprocessable_content
      end
    end

    # @route GET /fr/admin/ecosystem_items/:id/edit {locale: "fr"} (edit_admin_ecosystem_item_fr)
    # @route GET /es/admin/ecosystem_items/:id/edit {locale: "es"} (edit_admin_ecosystem_item_es)
    # @route GET /de/admin/ecosystem_items/:id/edit {locale: "de"} (edit_admin_ecosystem_item_de)
    # @route GET /it/admin/ecosystem_items/:id/edit {locale: "it"} (edit_admin_ecosystem_item_it)
    # @route GET /en/admin/ecosystem_items/:id/edit {locale: "en"} (edit_admin_ecosystem_item_en)
    # @route GET /admin/ecosystem_items/:id/edit
    def edit
      authorize! @ecosystem_item
    end

    # @route PATCH /fr/admin/ecosystem_items/:id {locale: "fr"} (admin_ecosystem_item_fr)
    # @route PATCH /es/admin/ecosystem_items/:id {locale: "es"} (admin_ecosystem_item_es)
    # @route PATCH /de/admin/ecosystem_items/:id {locale: "de"} (admin_ecosystem_item_de)
    # @route PATCH /it/admin/ecosystem_items/:id {locale: "it"} (admin_ecosystem_item_it)
    # @route PATCH /en/admin/ecosystem_items/:id {locale: "en"} (admin_ecosystem_item_en)
    # @route PATCH /admin/ecosystem_items/:id
    # @route PUT /fr/admin/ecosystem_items/:id {locale: "fr"} (admin_ecosystem_item_fr)
    # @route PUT /es/admin/ecosystem_items/:id {locale: "es"} (admin_ecosystem_item_es)
    # @route PUT /de/admin/ecosystem_items/:id {locale: "de"} (admin_ecosystem_item_de)
    # @route PUT /it/admin/ecosystem_items/:id {locale: "it"} (admin_ecosystem_item_it)
    # @route PUT /en/admin/ecosystem_items/:id {locale: "en"} (admin_ecosystem_item_en)
    # @route PUT /admin/ecosystem_items/:id
    def update
      authorize! @ecosystem_item

      if @ecosystem_item.update(ecosystem_item_params)
        flash[:notice] = t('.notice')

        redirect_to admin_ecosystem_items_path
      else
        render :edit, status: :unprocessable_content
      end
    end

    # @route DELETE /fr/admin/ecosystem_items/:id {locale: "fr"} (admin_ecosystem_item_fr)
    # @route DELETE /es/admin/ecosystem_items/:id {locale: "es"} (admin_ecosystem_item_es)
    # @route DELETE /de/admin/ecosystem_items/:id {locale: "de"} (admin_ecosystem_item_de)
    # @route DELETE /it/admin/ecosystem_items/:id {locale: "it"} (admin_ecosystem_item_it)
    # @route DELETE /en/admin/ecosystem_items/:id {locale: "en"} (admin_ecosystem_item_en)
    # @route DELETE /admin/ecosystem_items/:id
    def destroy
      authorize! @ecosystem_item

      @ecosystem_item.destroy

      flash[:notice] = t('.notice')

      redirect_to admin_ecosystem_items_path
    end

    private

    def ecosystem_item_params
      translated_params = I18n.available_locales.map do |l|
        [
          :"name_#{Mobility.normalize_locale(l)}",
          :"description_#{Mobility.normalize_locale(l)}"
        ]
      end.flatten

      params.expect(ecosystem_item: %i[
        url enabled picture remove_picture
      ].push(translated_params))
    end

    def set_ecosystem_item
      @ecosystem_item = EcosystemItem.find(params[:id])
    end
  end
end
