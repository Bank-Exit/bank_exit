class ContactsController < PublicController
  skip_after_action :record_page_view

  ALLOWED_CONTACTS = %w[Session Nostr Email].freeze

  # @route GET /fr/contacts/:id {locale: "fr"} (contact_fr)
  # @route GET /es/contacts/:id {locale: "es"} (contact_es)
  # @route GET /de/contacts/:id {locale: "de"} (contact_de)
  # @route GET /it/contacts/:id {locale: "it"} (contact_it)
  # @route GET /en/contacts/:id {locale: "en"} (contact_en)
  # @route GET /contacts/:id
  def show
    unless params[:id].in?(ALLOWED_CONTACTS)
      head :not_found
      return
    end

    @contact = @contacts.find { |c| c.title == params[:id] }
  end
end
