module Merchandable
  include ActiveSupport::Concern
  include MerchantsHelper

  private

  def merchant_ids
    @merchant_ids ||= Rails.cache.fetch(
      "#{merchants_cache_key}:ids",
      expires_in: 6.hours
    ) do
      FilterMerchants.call(
        query: query,
        category: category,
        country: country,
        continent: continent,
        coins: coins,
        delivery: delivery?,
        no_kyc: no_kyc?,
        with_atms: with_atms?,
        order_by_survey: order_by_survey?
      ).select(:id)
    end
  end

  def merchants_markers
    @merchants_markers ||= Rails.cache.fetch(
      "#{I18n.locale}:#{merchants_cache_key}:json",
      expires_in: 6.hours
    ) do
      merchants = Merchant
                  .select(:identifier, :icon, :latitude, :longitude, :coins)
                  .where(id: merchant_ids)

      MerchantDecorator.wrap(merchants).map(&:to_osm_map)
    end
  end

  def query
  end

  def category
  end

  def country
  end

  def continent
  end

  def coins
    []
  end

  def delivery?
    false
  end

  def no_kyc?
    false
  end

  def with_atms?
    session[:include_atms]
  end

  def order_by_survey?
    false
  end

  def merchants_cache_key
    @merchants_cache_key ||= [
      'MERCHANTS_FILTER',
      ("query=#{query}" if query.present?),
      ("category=#{category}" if category.present?),
      ("country=#{country}" if country.present?),
      ("continent=#{continent}" if continent.present?),
      ("coins=#{coins.join('-')}" if coins.any?),
      "delivery=#{delivery? || false}",
      "no-kyc=#{no_kyc? || 'undefined'}",
      "atms=#{with_atms? || false}",
      "order-survey=#{order_by_survey? || false}"
    ].compact.join(':')
  end
end
