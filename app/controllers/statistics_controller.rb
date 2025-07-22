class StatisticsController < PublicController
  include Statisticable

  before_action :set_statistics

  # @route GET /fr/stats {locale: "fr"} (statistics_fr)
  # @route GET /es/stats {locale: "es"} (statistics_es)
  # @route GET /de/stats {locale: "de"} (statistics_de)
  # @route GET /it/stats {locale: "it"} (statistics_it)
  # @route GET /en/stats {locale: "en"} (statistics_en)
  # @route GET /stats (stats)
  def show
  end
end
