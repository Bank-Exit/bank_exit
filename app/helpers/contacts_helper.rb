module ContactsHelper
  def social_contact_icon(mode, klass: 'mr-1', title: nil)
    icon_klass = "inline-flex w-5 #{klass}"
    image_klass = "inline-flex w-6 rounded-lg #{klass}"
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
    when :session, :signal, :matrix, :jabber, :telegram, :facebook, :instagram, :twitter, :youtube, :odysee, :tiktok, :linkedin, :substack, :tripadvisor, :simplex, :crowdbunker, :francelibretv, :nostr
      inline_svg_tag "contacts/#{mode}.svg", class: image_klass, title: label, alt: label
    end
  end
end
