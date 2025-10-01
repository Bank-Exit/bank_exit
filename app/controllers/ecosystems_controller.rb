class EcosystemsController < PublicController
  # @route GET /fr/ecosystem {locale: "fr"} (ecosystem_fr)
  # @route GET /es/ecosystem {locale: "es"} (ecosystem_es)
  # @route GET /de/ecosystem {locale: "de"} (ecosystem_de)
  # @route GET /it/ecosystem {locale: "it"} (ecosystem_it)
  # @route GET /en/ecosystem {locale: "en"} (ecosystem_en)
  # @route GET /ecosystem
  def show
    @ecosystem_items = EcosystemItem.enabled
  end
end
