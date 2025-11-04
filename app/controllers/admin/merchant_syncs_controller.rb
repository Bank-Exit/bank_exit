module Admin
  class MerchantSyncsController < BaseController
    before_action :set_merchant_sync, only: :show

    # @route GET /fr/admin/merchant_syncs {locale: "fr"} (admin_merchant_syncs_fr)
    # @route GET /es/admin/merchant_syncs {locale: "es"} (admin_merchant_syncs_es)
    # @route GET /de/admin/merchant_syncs {locale: "de"} (admin_merchant_syncs_de)
    # @route GET /it/admin/merchant_syncs {locale: "it"} (admin_merchant_syncs_it)
    # @route GET /en/admin/merchant_syncs {locale: "en"} (admin_merchant_syncs_en)
    # @route GET /admin/merchant_syncs
    def index
      authorize!

      @dashboard_presenter = Admin::DashboardPresenter.new
      @merchant_sync = MerchantSync.sync.last

      @pagy, @merchant_syncs = pagy(MerchantSync.all.reverse_order)
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

    private

    def set_merchant_sync
      @merchant_sync = MerchantSync.find(params[:id])
    end
  end
end
