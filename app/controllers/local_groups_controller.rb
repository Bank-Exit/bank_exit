class LocalGroupsController < PublicController
  # @route GET /fr/local_groups {locale: "fr"} (local_groups_fr)
  # @route GET /es/local_groups {locale: "es"} (local_groups_es)
  # @route GET /de/local_groups {locale: "de"} (local_groups_de)
  # @route GET /it/local_groups {locale: "it"} (local_groups_it)
  # @route GET /en/local_groups {locale: "en"} (local_groups_en)
  # @route GET /local_groups
  def index
    @local_groups = LocalGroup.all
  end
end
