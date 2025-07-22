class FAQsController < PublicController
  # @route GET /fr/faq {locale: "fr"} (faq_fr)
  # @route GET /es/faq {locale: "es"} (faq_es)
  # @route GET /de/faq {locale: "de"} (faq_de)
  # @route GET /it/faq {locale: "it"} (faq_it)
  # @route GET /en/faq {locale: "en"} (faq_en)
  # @route GET /faq
  def show
    @faqs = FAQ.all
  end
end
