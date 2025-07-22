class CoinsController < PublicController
  before_action :set_coin

  # @route GET /fr/coins/:id {locale: "fr"} (coin_fr)
  # @route GET /es/coins/:id {locale: "es"} (coin_es)
  # @route GET /de/coins/:id {locale: "de"} (coin_de)
  # @route GET /it/coins/:id {locale: "it"} (coin_it)
  # @route GET /en/coins/:id {locale: "en"} (coin_en)
  # @route GET /coins/:id
  def show
  end

  private

  def identifier
    params[:id].presence || 'bitcoin'
  end

  def set_coin
    @coin = Coin.find(identifier, decorate: true)
  end
end
