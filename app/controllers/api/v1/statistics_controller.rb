module API
  module V1
    class StatisticsController < BaseController
      # @route GET /fr/api/v1/statistics {locale: "fr"} (api_v1_statistics_fr)
      # @route GET /es/api/v1/statistics {locale: "es"} (api_v1_statistics_es)
      # @route GET /de/api/v1/statistics {locale: "de"} (api_v1_statistics_de)
      # @route GET /it/api/v1/statistics {locale: "it"} (api_v1_statistics_it)
      # @route GET /en/api/v1/statistics {locale: "en"} (api_v1_statistics_en)
      # @route GET /api/v1/statistics
      def show
        @presenter = API::StatisticsPresenter.new(include_atms: with_atms?)

        @merchants_statistics = @presenter.merchants_statistics
        @countries_statistics = @presenter.countries_statistics
        @categories_statistics = @presenter.categories_statistics
        @coins_statistics = @presenter.coins_statistics
        @directories_statistics = @presenter.directories_statistics

        @last_checked_at = merchant_sync.ended_at.iso8601 if merchant_sync
      end

      private

      def with_atms?
        params[:atms] == 'true'
      end

      def merchant_sync
        @merchant_sync ||= MerchantSync.success.last
      end
    end
  end
end
