class MerchantDecorator < ProfesionalDecorator
  include ApplicationHelper
  include Rails.application.routes.url_helpers

  TICKERS = {
    bitcoin: 'BTC',
    monero: 'XMR',
    lightning: 'BTC-LN',
    june: 'G1'
  }.freeze

  def address?
    full_address.present? || country.present?
  end

  def full_address_with_country(show_flag: true, expanded: true)
    @full_address_with_country ||= begin
      lines = if expanded
                line_1 = [house_number, street].compact_blank.join(' ')
                line_2 = [postcode, city].compact_blank.join(' ')

                [line_1, line_2]
              else
                line = [house_number, street, postcode, city]

                [line.compact_blank.join(' ')]
              end

      lines << pretty_country(show_flag: show_flag)
      lines.compact_blank.join('<br />')
    end
  end

  def contact?
    phone? || email? || website? || social_networks?
  end

  def social_networks?
    contact_session? || contact_signal? || contact_matrix? ||
      contact_jabber? || contact_telegram? || contact_facebook? ||
      contact_instagram? || contact_twitter? || contact_youtube? ||
      contact_tiktok? || contact_linkedin? || contact_tripadvisor? || contact_odysee? ||
      contact_crowdbunker? || contact_francelibretv?
  end

  def opening_hours_sentences
    @opening_hours_sentences ||= OpeningHoursParser.call(opening_hours)
  end

  def osm_link
    "https://www.openstreetmap.org/#{original_identifier}"
  end

  def ticker_coins
    coins.map do |coin|
      TICKERS[coin.to_sym]
    end
  end

  def all_links
    [
      contact_session,
      contact_signal,
      contact_matrix,
      contact_jabber,
      contact_telegram,
      contact_facebook,
      contact_instagram,
      contact_twitter,
      contact_youtube,
      contact_odysee,
      contact_crowdbunker,
      contact_francelibretv,
      contact_tiktok,
      contact_linkedin,
      contact_tripadvisor,
      osm_link
    ].compact_blank
  end

  def pretty_country(show_flag: true)
    pretty_country_html(country, show_flag: show_flag)
  end

  def to_osm_map
    {
      identifier: identifier,
      icon: icon,
      latitude: latitude,
      longitude: longitude,
      coins: coins,
      popup_path: merchant_popup_path(identifier)
    }
  end

  def might_be_outdated?
    return false unless object.last_survey_on

    last_survey_on.before?(3.years.ago)
  end
end
