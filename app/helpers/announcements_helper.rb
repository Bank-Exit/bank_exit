module AnnouncementsHelper
  def announcement_color_by_mode(mode)
    case mode
    when 'success' then 'badge-success'
    when 'info' then 'badge-info'
    when 'warning' then 'badge-warning'
    when 'error' then 'badge-error'
    else
      ''
    end
  end

  def announcement_locale_select_helper
    I18n.available_locales.map do |locale|
      [
        "#{emoji_by_locale(locale)} #{Rails.configuration.i18n_human_languages[locale]}",
        locale
      ]
    end
  end
end
