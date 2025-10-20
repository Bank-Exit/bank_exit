class WelcomeController < PublicController
  include Merchandable
  include Statisticable

  before_action :set_statistics

  # @route GET /fr {locale: "fr"} (root_fr)
  # @route GET /es {locale: "es"} (root_es)
  # @route GET /de {locale: "de"} (root_de)
  # @route GET /it {locale: "it"} (root_it)
  # @route GET /en {locale: "en"} (root_en)
  # @route GET / (root)
  def index
    @coins = Coin.all(decorate: true)
    @highlighted_tutorials = Tutorial.all(decorate: true).select(&:highlight?)

    @faqs = FAQ.all.first(3)
    @minimal_faq = true

    @profiles = Questions::BuildProfiles.call
    @levels = Questions::BuildLevels.call

    merchants_sample = Merchant.available.monero.in_france.no_kyc.includes(:logo_attachment, :banner_attachment).sample(3)
    @merchants_sample = MerchantDecorator.wrap(merchants_sample)
  end
end
