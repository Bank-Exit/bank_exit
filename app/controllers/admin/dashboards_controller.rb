module Admin
  class DashboardsController < BaseController
    # @route GET /fr/admin {locale: "fr"} (admin_root_fr)
    # @route GET /es/admin {locale: "es"} (admin_root_es)
    # @route GET /de/admin {locale: "de"} (admin_root_de)
    # @route GET /it/admin {locale: "it"} (admin_root_it)
    # @route GET /en/admin {locale: "en"} (admin_root_en)
    # @route GET /admin
    # @route GET /fr/admin/dashboard {locale: "fr"} (admin_dashboard_fr)
    # @route GET /es/admin/dashboard {locale: "es"} (admin_dashboard_es)
    # @route GET /de/admin/dashboard {locale: "de"} (admin_dashboard_de)
    # @route GET /it/admin/dashboard {locale: "it"} (admin_dashboard_it)
    # @route GET /en/admin/dashboard {locale: "en"} (admin_dashboard_en)
    # @route GET /admin/dashboard
    def show
      @dashboard_presenter = Admin::DashboardPresenter.new

      @merchants_statistics = @dashboard_presenter.merchants_statistics
      @countries_statistics = @dashboard_presenter.countries_statistics
      @categories_statistics = @dashboard_presenter.categories_statistics
      @coins_statistics = @dashboard_presenter.coins_statistics
      @directories_statistics = @dashboard_presenter.directories_statistics
    end
  end
end
