module ContactsHelper
  def social_contact_icon(mode, klass: 'mr-1', title: nil)
    icon_klass = "inline-flex w-4 #{klass}"
    image_klass = "inline-flex w-4 rounded-lg #{klass}"
    i18n_scope = 'activerecord.attributes.contact_way.roles'
    label = title.presence || t(mode.to_sym, scope: i18n_scope)

    case mode.to_sym
    when :phone
      if title
        content_tag(:span, title: title) do
          lucide_icon 'phone', class: icon_klass
        end
      else
        lucide_icon 'phone', class: icon_klass
      end
    when :email
      if title
        content_tag(:span, title: title) do
          lucide_icon 'mail', class: icon_klass
        end
      else
        lucide_icon 'mail', class: icon_klass
      end
    when :website
      if title
        content_tag(:span, title: title) do
          lucide_icon 'link', class: icon_klass
        end
      else
        lucide_icon 'link', class: icon_klass
      end
    when :nostr
      image_tag 'contacts/nostr.svg', class: image_klass, title: label, alt: label
    when :session, :signal, :matrix, :jabber, :telegram, :facebook, :instagram, :twitter, :youtube, :odysee, :tiktok, :linkedin, :substack, :tripadvisor
      image_tag "contacts/#{mode}.svg", class: image_klass, title: label, alt: label
    when :crowdbunker
      label = title.presence || t(:crowdbunker, scope: i18n_scope)
      image_tag 'contacts/crowdbunker.png', class: image_klass, title: label, alt: label
    when :francelibretv, :simplex
      image_tag "contacts/#{mode}.webp", class: image_klass, title: label, alt: label
    end
  end
end
