class FilterMerchants < ApplicationService
  attr_reader :initial_scope, :query, :category,
              :country, :continent, :coins,
              :delivery, :no_kyc, :with_atms,
              :order_by_survey, :onchain_only

  def initialize(initial_scope = Merchant.available, query: '', category: 'all', country: 'all', continent: 'all', coins: [], onchain_only: false, delivery: false, no_kyc: false, with_atms: false, order_by_survey: false)
    @initial_scope = initial_scope
    @query = query
    @category = category
    @country = country
    @continent = continent
    @coins = coins
    @onchain_only = onchain_only
    @delivery = delivery
    @no_kyc = no_kyc
    @with_atms = with_atms
    @order_by_survey = order_by_survey
  end

  def call
    @merchants = initial_scope

    @merchants = if order_by_survey
                   @merchants.order(
                     Arel.sql('last_survey_on IS NULL, last_survey_on DESC')
                   )
                 else
                   @merchants.order(created_at: :desc)
                 end

    @merchants = @merchants.where(delivery: delivery) if delivery
    @merchants = @merchants.by_query(query) if query.present?
    @merchants = @merchants.by_category(category) if category.present? && category != 'all'

    # Ignore country if both params are present
    if continent.present? && continent != 'all'
      @merchants = @merchants.by_continent(continent)
    elsif country.present? && country != 'all'
      @merchants = @merchants.by_country(country)
    end

    @merchants = @merchants.no_kyc if no_kyc
    @merchants = @merchants.not_atms unless with_atms
    @merchants = @merchants.merge(Merchant.onchain_only) if onchain_only

    return @merchants unless bitcoin? || monero? || june?

    bitcoin_scope =
      if bitcoin?
        if onchain_only
          Merchant.merge(Merchant.bitcoin_onchain)
        else
          Merchant.merge(Merchant.bitcoin)
        end
      else
        Merchant.none
      end

    @merchants.and(
      Merchant.none.or(
        bitcoin_scope
      ).or(
        monero? ? Merchant.merge(Merchant.monero) : Merchant.none
      ).or(
        june? ? Merchant.merge(Merchant.june) : Merchant.none
      )
    )
  end

  private

  def bitcoin?
    coins.include?('bitcoin')
  end

  def monero?
    coins.include?('monero')
  end

  def june?
    coins.include?('june')
  end
end
