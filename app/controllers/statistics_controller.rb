class StatisticsController < PublicController
  include Statisticable

  before_action :set_statistics, only: :show
  skip_after_action :record_page_view, only: %i[
    daily_merchants toggle_atms
  ]

  # @route GET /fr/stats {locale: "fr"} (statistics_fr)
  # @route GET /es/stats {locale: "es"} (statistics_es)
  # @route GET /de/stats {locale: "de"} (statistics_de)
  # @route GET /it/stats {locale: "it"} (statistics_it)
  # @route GET /en/stats {locale: "en"} (statistics_en)
  # @route GET /stats (stats)
  def show
  end

  # @route GET /fr/stats/daily_merchants {locale: "fr"} (daily_merchants_statistics_fr)
  # @route GET /es/stats/daily_merchants {locale: "es"} (daily_merchants_statistics_es)
  # @route GET /de/stats/daily_merchants {locale: "de"} (daily_merchants_statistics_de)
  # @route GET /it/stats/daily_merchants {locale: "it"} (daily_merchants_statistics_it)
  # @route GET /en/stats/daily_merchants {locale: "en"} (daily_merchants_statistics_en)
  # @route GET /stats/daily_merchants
  def daily_merchants
    begin
      @date = Date.parse(params[:date])
      @date = Date.current unless @date.between?(1.week.ago.to_date, Date.current)
    rescue TypeError, Date::Error
      @date = Date.current
    end

    merchants = Merchant.available.where(created_at: @date.all_day).order(created_at: :desc)
    merchants.not_atms unless session[:include_atms]

    @merchants = MerchantDecorator.wrap(merchants)
  end

  # @route POST /statistics/toggle_atms (statistics_toggle_atms)
  def toggle_atms
    session[:include_atms] = params[:include_atms]
  end
end
