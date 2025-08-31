module MerchantsGPXHelper
  def merchant_metadata_filename(coins, category, continent, country, query)
    [
      'merchants',
      coins&.join('_'),
      category,
      continent,
      country,
      query,
      Date.current.to_s
    ].compact_blank.join('_').downcase
  end

  def merchant_metadata_title(coins, category, continent, country, query)
    [
      Merchant.model_name.human(count: 2),
      coins.map(&:capitalize).join(', '),
      (I18n.t(category, scope: :categories) if category),
      (I18n.t(continent, scope: :continents) if continent),
      (pretty_country_html(country) if country),
      query.presence || nil,
      "#{I18n.l(Date.current)} 🚀"
    ].compact_blank.join(' - ')
  end

  def merchant_metadata_email
    Contact.all.find(&:email?).links.first
  end

  def merchant_icon(merchant)
    icon = []
    icon << '🟠' if merchant.monero?
    icon << '🟡' if merchant.bitcoin? || merchant.lightning? || merchant.contact_less?
    icon << '🌀' if merchant.june?
  end

  def merchant_description(merchant)
    lines = []

    crypto_summary = []
    crypto_summary << '₿ Bitcoin' if merchant.bitcoin?
    crypto_summary << '🔒 Monero' if merchant.monero?
    crypto_summary << '🌀 June' if merchant.june?
    crypto_summary << '⚡ Lightning' if merchant.lightning? || merchant.contact_less?
    lines << "#{merchant_icon(merchant)} #{crypto_summary.join(' + ')}" unless crypto_summary.empty?

    # Category
    lines << "🏛️ Service: #{I18n.t(merchant.category, scope: 'categories')}" if merchant.category.present?

    # Address
    lines << "📍 #{merchant.house_number} #{merchant.street}".strip if merchant.house_number.present? || merchant.street.present?
    lines << "🏙️ #{merchant.postcode} #{merchant.city}".strip if merchant.city.present? || merchant.postcode.present?

    # Opening hours
    lines << "🕒 #{merchant.opening_hours}" if merchant.opening_hours.present?

    # Contact info
    merchant.all_contacts.each do |contact_way, contact_value|
      icon = '🌐'
      icon = '📞' if contact_way == :phone
      icon = '✉️' if contact_way == :email

      lines << "#{icon} #{contact_value}"
    end

    # Bank-Exit merchant page URL
    lines << "🌐 #{merchant_url(merchant)}"

    lines.join("\n")
  end
end
