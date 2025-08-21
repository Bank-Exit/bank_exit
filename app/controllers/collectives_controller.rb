class CollectivesController < PublicController
  # @route GET /fr/collective {locale: "fr"} (collective_fr)
  # @route GET /es/collective {locale: "es"} (collective_es)
  # @route GET /de/collective {locale: "de"} (collective_de)
  # @route GET /it/collective {locale: "it"} (collective_it)
  # @route GET /en/collective {locale: "en"} (collective_en)
  # @route GET /collective
  def show
    local_groups = LocalGroup.all
    @local_groups_count = local_groups.first.france_count
  end
end
