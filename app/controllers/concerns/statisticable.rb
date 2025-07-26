module Statisticable
  include ActiveSupport::Concern

  def set_statistics
    @statistics_presenter = StatisticsPresenter.new(include_atms: session[:include_atms])

    @merchants_statistics = @statistics_presenter.merchants_statistics
    @countries_statistics = @statistics_presenter.countries_statistics
    @categories_statistics = @statistics_presenter.categories_statistics
    @coins_statistics = @statistics_presenter.coins_statistics

    @directories_statistics = @statistics_presenter.directories_statistics
  end
end
