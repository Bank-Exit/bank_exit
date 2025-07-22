class CoinWalletsController < PublicController
  before_action :set_coin_wallet

  # @route GET /fr/coin_wallets/:id {locale: "fr"} (coin_wallet_fr)
  # @route GET /es/coin_wallets/:id {locale: "es"} (coin_wallet_es)
  # @route GET /de/coin_wallets/:id {locale: "de"} (coin_wallet_de)
  # @route GET /it/coin_wallets/:id {locale: "it"} (coin_wallet_it)
  # @route GET /en/coin_wallets/:id {locale: "en"} (coin_wallet_en)
  # @route GET /coin_wallets/:id
  def show
    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def set_coin_wallet
    @coin_wallet = CoinWallet.enabled.find(params[:id])
  end
end
