module Admin
  class MerchantSyncsController < BaseController
    before_action :set_merchant_sync, only: %i[show edit update destroy]

    # @route GET /fr/admin/merchant_syncs {locale: "fr"} (admin_merchant_syncs_fr)
    # @route GET /es/admin/merchant_syncs {locale: "es"} (admin_merchant_syncs_es)
    # @route GET /de/admin/merchant_syncs {locale: "de"} (admin_merchant_syncs_de)
    # @route GET /it/admin/merchant_syncs {locale: "it"} (admin_merchant_syncs_it)
    # @route GET /en/admin/merchant_syncs {locale: "en"} (admin_merchant_syncs_en)
    # @route GET /admin/merchant_syncs
    def index
      authorize!

      merchant_syncs = if query.present?
                         MerchantSync.by_query(query).order(created_at: :desc)
                       else
                         MerchantSync.all.reverse_order
                       end

      @pagy, @merchant_syncs = pagy(merchant_syncs)

      respond_to do |format|
        format.html do
          @dashboard_presenter = Admin::DashboardPresenter.new
          @merchant_sync = MerchantSync.sync.last
        end
        format.turbo_stream if params[:turbo_stream] == 'true'
      end
    end

    # @route GET /fr/admin/merchant_syncs/:id {locale: "fr"} (admin_merchant_sync_fr)
    # @route GET /es/admin/merchant_syncs/:id {locale: "es"} (admin_merchant_sync_es)
    # @route GET /de/admin/merchant_syncs/:id {locale: "de"} (admin_merchant_sync_de)
    # @route GET /it/admin/merchant_syncs/:id {locale: "it"} (admin_merchant_sync_it)
    # @route GET /en/admin/merchant_syncs/:id {locale: "en"} (admin_merchant_sync_en)
    # @route GET /admin/merchant_syncs/:id
    def show
      authorize!
    end

    # @route GET /fr/admin/merchant_syncs/:id/edit {locale: "fr"} (edit_admin_merchant_sync_fr)
    # @route GET /es/admin/merchant_syncs/:id/edit {locale: "es"} (edit_admin_merchant_sync_es)
    # @route GET /de/admin/merchant_syncs/:id/edit {locale: "de"} (edit_admin_merchant_sync_de)
    # @route GET /it/admin/merchant_syncs/:id/edit {locale: "it"} (edit_admin_merchant_sync_it)
    # @route GET /en/admin/merchant_syncs/:id/edit {locale: "en"} (edit_admin_merchant_sync_en)
    # @route GET /admin/merchant_syncs/:id/edit
    def edit
      authorize! @merchant_sync
    end

    # @route PATCH /fr/admin/merchant_syncs/:id {locale: "fr"} (admin_merchant_sync_fr)
    # @route PATCH /es/admin/merchant_syncs/:id {locale: "es"} (admin_merchant_sync_es)
    # @route PATCH /de/admin/merchant_syncs/:id {locale: "de"} (admin_merchant_sync_de)
    # @route PATCH /it/admin/merchant_syncs/:id {locale: "it"} (admin_merchant_sync_it)
    # @route PATCH /en/admin/merchant_syncs/:id {locale: "en"} (admin_merchant_sync_en)
    # @route PATCH /admin/merchant_syncs/:id
    # @route PUT /fr/admin/merchant_syncs/:id {locale: "fr"} (admin_merchant_sync_fr)
    # @route PUT /es/admin/merchant_syncs/:id {locale: "es"} (admin_merchant_sync_es)
    # @route PUT /de/admin/merchant_syncs/:id {locale: "de"} (admin_merchant_sync_de)
    # @route PUT /it/admin/merchant_syncs/:id {locale: "it"} (admin_merchant_sync_it)
    # @route PUT /en/admin/merchant_syncs/:id {locale: "en"} (admin_merchant_sync_en)
    # @route PUT /admin/merchant_syncs/:id
    def update
      authorize! @merchant_sync

      if @merchant_sync.update(merchant_sync_update_params)
        flash[:notice] = t('.notice')

        redirect_to admin_merchant_syncs_path
      else
        render :edit, status: :unprocessable_content
      end
    end

    # @route DELETE /fr/admin/merchant_syncs/:id {locale: "fr"} (admin_merchant_sync_fr)
    # @route DELETE /es/admin/merchant_syncs/:id {locale: "es"} (admin_merchant_sync_es)
    # @route DELETE /de/admin/merchant_syncs/:id {locale: "de"} (admin_merchant_sync_de)
    # @route DELETE /it/admin/merchant_syncs/:id {locale: "it"} (admin_merchant_sync_it)
    # @route DELETE /en/admin/merchant_syncs/:id {locale: "en"} (admin_merchant_sync_en)
    # @route DELETE /admin/merchant_syncs/:id
    def destroy
      authorize! @merchant_sync

      @merchant_sync.destroy

      flash[:notice] = t('.notice')

      redirect_back_or_to admin_merchant_syncs_path
    end

    private

    def merchant_sync_params
      params.permit(:query)
    end

    def merchant_sync_update_params
      params.expect(
        merchant_sync: %i[
          added_merchants_count
          updated_merchants_count
          soft_deleted_merchants_count
          payload_added_merchants
          payload_updated_merchants
          payload_soft_deleted_merchants
          payload_countries
          payload_nostr
          notes
        ]
      )
    end

    def set_merchant_sync
      @merchant_sync = MerchantSync.find(params[:id])
    end

    def query
      merchant_sync_params[:query]
    end
  end
end
