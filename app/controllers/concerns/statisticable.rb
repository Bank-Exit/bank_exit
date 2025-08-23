module Statisticable
  include ActiveSupport::Concern

  CACHE_EXPIRES_IN = 6.hours

  def set_statistics
    @statistics_presenter = StatisticsPresenter.new(include_atms: include_atms?)

    @merchants_statistics = Rails.cache.fetch(
      "concerns/statistics:merchants:with_atms=#{cache_key_suffix}",
      expires_in: CACHE_EXPIRES_IN
    ) do
      @statistics_presenter.merchants_statistics
    end

    @countries_statistics = Rails.cache.fetch(
      "concerns/statistics:countries:#{cache_key_suffix}",
      expires_in: CACHE_EXPIRES_IN
    ) do
      @statistics_presenter.countries_statistics
    end

    @categories_statistics = Rails.cache.fetch(
      "concerns/statistics:categories:#{cache_key_suffix}",
      expires_in: CACHE_EXPIRES_IN
    ) do
      @statistics_presenter.categories_statistics
    end

    @coins_statistics = Rails.cache.fetch(
      "concerns/statistics:coins:#{cache_key_suffix}",
      expires_in: CACHE_EXPIRES_IN
    ) do
      @statistics_presenter.coins_statistics
    end

    @directories_statistics = Rails.cache.fetch(
      "concerns/statistics:directories:#{cache_key_suffix}",
      expires_in: CACHE_EXPIRES_IN
    ) do
      @statistics_presenter.directories_statistics
    end
  end

  private

  def cache_key_suffix
    "locale=#{I18n.locale}:with_atms=#{session[:include_atms]}"
  end

  def include_atms?
    session[:include_atms]
  end
end
