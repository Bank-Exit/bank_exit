class GlossariesController < PublicController
  # @route GET /fr/glossaries {locale: "fr"} (glossaries_fr)
  # @route GET /es/glossaries {locale: "es"} (glossaries_es)
  # @route GET /de/glossaries {locale: "de"} (glossaries_de)
  # @route GET /it/glossaries {locale: "it"} (glossaries_it)
  # @route GET /en/glossaries {locale: "en"} (glossaries_en)
  # @route GET /glossaries
  def show
    glossaries = Glossary.load_from_yaml_file
    @glossaries = glossaries.group_by(&:letter)
  end
end
