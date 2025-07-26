module Merchandable
  include ActiveSupport::Concern
  include MerchantsHelper

  private

  def set_merchants
    merchants = FilterMerchants.call(
      query: query,
      category: category,
      country: country,
      continent: continent,
      coins: coins,
      delivery: delivery?,
      no_kyc: no_kyc?,
      with_atms: with_atms?
    )

    @merchants = MerchantDecorator.wrap(merchants)
  end

  def set_markers
    @merchant_markers = @merchants.map(&:to_osm_map)
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
end
