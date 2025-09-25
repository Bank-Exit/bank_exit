class AnnouncementsController < PublicController
  # @route GET /fr/announcements {locale: "fr"} (announcements_fr)
  # @route GET /es/announcements {locale: "es"} (announcements_es)
  # @route GET /de/announcements {locale: "de"} (announcements_de)
  # @route GET /it/announcements {locale: "it"} (announcements_it)
  # @route GET /en/announcements {locale: "en"} (announcements_en)
  # @route GET /announcements
  def index
    @announcements = Announcement.enabled.published.where(
      locale: I18n.locale
    )
  end
end
