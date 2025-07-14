module Admin
  class DashboardsController < BaseController
    # @route GET /admin (admin_root)
    # @route GET /admin/dashboard (admin_dashboard)
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
