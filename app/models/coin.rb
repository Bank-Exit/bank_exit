class Coin
  include ActiveModel::Model
  include ActiveModel::Attributes
  include Findable

  attribute :identifier, :string
  attribute :name, :string
  attribute :short_name, :string
  attribute :ticker, :string
  attribute :usage, :string

  attr_accessor :links, :description

  def ticker?
    ticker.present?
  end

  def links?
    links.present?
  end

  def bitcoin_ln?
    identifier.match?('bitcoin-lightning-network')
  end
end
