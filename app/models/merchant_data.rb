# This class acts as a mapper between json API data and
# project database structure.
class MerchantData
  attr_reader :feature

  def initialize(feature)
    @feature = feature
  end

  def json
    {
      identifier: identifier,
      original_identifier: original_id,
      name: name,
      slug: slug,
      description: description,

      house_number: house_number,
      street: street,
      postcode: postcode,
      city: city,
      # As country is almost never returned by OSM, reverse
      # geocoding is used to assign the corresponding country
      # associated to a given lat/lon.
      full_address: full_address.presence,

      website: website,
      email: email,
      phone: phone,

      coins: coins,
      bitcoin: bitcoin?,
      lightning: lightning?,
      monero: monero?,
      june: june?,
      contact_less: contact_less?,

      latitude: latitude,
      longitude: longitude,

      # Social networks

      contact_session: SocialUrlPrefixer.call(:session, properties['contact:session']),
      contact_signal: SocialUrlPrefixer.call(:signal, properties['contact:signal']),
      contact_matrix: SocialUrlPrefixer.call(:matrix, properties['contact:matrix']),
      contact_jabber: SocialUrlPrefixer.call(:jabber, properties['contact:jabber']),
      contact_telegram: SocialUrlPrefixer.call(:telegram, properties['contact:telegram']),
      contact_facebook: SocialUrlPrefixer.call(:facebook, properties['contact:facebook']),
      contact_instagram: SocialUrlPrefixer.call(:instagram, properties['contact:instagram']),
      contact_twitter: SocialUrlPrefixer.call(:twitter, properties['contact:twitter']),
      contact_youtube: SocialUrlPrefixer.call(:youtube, properties['contact:youtube']),
      contact_tiktok: SocialUrlPrefixer.call(:tiktok, properties['contact:tiktok']),
      contact_linkedin: SocialUrlPrefixer.call(:linkedin, properties['contact:linkedin']),
      contact_tripadvisor: SocialUrlPrefixer.call(:tripadvisor, properties['contact:tripadvisor']),
      contact_odysee: SocialUrlPrefixer.call(:odysee, properties['contact:odysee']),
      contact_crowdbunker: SocialUrlPrefixer.call(:crowdbunker, properties['contact:crowdbunker']),
      contact_francelibretv: SocialUrlPrefixer.call(:francelibretv, properties['contact:francelibretv']),

      ask_kyc: ask_kyc,

      delivery: delivery?,
      delivery_zone: delivery_zone,
      opening_hours: opening_hours,
      last_survey_on: last_survey_on,

      icon: icon,
      category: category,
      geometry: geometry,
      raw_feature: feature
    }
  end

  private

  # eg: node/58062559
  def original_id
    feature['id']
  end

  # eg: node/58062559 => 58062559
  def identifier
    original_id.split('/').last
  end

  def name
    properties['name'].presence || properties['brand'] || original_id
  end

  def slug
    name.parameterize
  end

  def description
    properties['description'] || properties['note']
  end

  # Address

  def full_address
    <<~STRING.squish
      #{house_number} #{street}
      #{postcode} #{city}
    STRING
  end

  def house_number
    properties['addr:housenumber'] || properties['contact:housenumber']
  end

  def street
    properties['addr:street'] ||
      properties['contact:street'] ||
      properties['addr:place']
  end

  def postcode
    properties['addr:postcode'] || properties['contact:postcode']
  end

  def city
    properties['addr:city'] || properties['contact:city']
  end

  # Coordinates

  def latitude
    return unless coordinates

    coordinates[1]
  end

  def longitude
    return unless coordinates

    coordinates[0]
  end

  def coordinates
    @coordinates ||= if geometry.empty?
                       nil
                     elsif polygon?
                       # {
                       #   "coordinates": [
                       #     [
                       #       [7.7556551, 48.6221281],
                       #       ...
                       #     ]
                       #   ]
                       # }
                       geometry['coordinates'].first.first
                     else
                       # {
                       #   "coordinates": [7.7556551, 48.6221281],
                       # }
                       geometry['coordinates']
                     end
  end

  def polygon?
    geometry['type'] == 'Polygon'
  end

  # Contact

  def website
    value = properties['website'] || properties['contact:website']

    return unless value

    value.split('?').first
  end

  def email
    properties['email'] || properties['contact:email']
  end

  def phone
    keys = %w[
      phone contact:phone
      mobile contact:mobile phone:mobile
    ]

    value = keys.lazy
                .map { |k| properties[k] }
                .find(&:present?)

    return unless value

    value.split(';').first
  end

  # Coins

  def coins
    [].tap do |array|
      # Bitcoin related
      array << 'bitcoin' if bitcoin?
      array << 'lightning' if lightning?
      array << 'lightning_contactless' if contact_less?

      array << 'monero' if monero?
      array << 'june' if june?
    end
  end

  def bitcoin?
    return false if properties['payment:onchain'] == 'no'

    properties['currency:XBT'] == 'yes' || properties['payment:onchain'] == 'yes'
  end

  def lightning?
    properties['payment:lightning'] == 'yes'
  end

  def contact_less?
    properties['payment:lightning_contactless'] == 'yes'
  end

  def june?
    properties['currency:XG1'] == 'yes' ||
      properties['currency:June'] == 'yes'
  end

  def monero?
    properties['currency:XMR'] == 'yes'
  end

  # KYC

  def ask_kyc
    return nil unless properties['payment:kyc']

    properties['payment:kyc'] == 'yes'
  end

  # Delivery

  def delivery?
    properties['delivery'] == 'yes'
  end

  def delivery_zone
    properties['delivery:zone']
  end

  def opening_hours
    properties['opening_hours']
  end

  def last_survey_on
    candidates = [
      properties['check_date'],
      properties['check_date:currency:XMR'],
      properties['check_date:currency:XBT'],
      properties['check_date:currency:XG1'],
      properties['check_date:currencies'],

      properties['survey:date'],
      properties['survey:date:currency:XMR'],
      properties['survey:date:currency:XBT'],
      properties['survey:date:currency:XG1'],
      properties['survey:date:currencies']
    ].compact_blank

    return nil if candidates.empty?

    candidates = candidates.map do |candidate|
      Date.parse(candidate)
    rescue Date::Error
      nil
    end

    candidates = candidates.compact.select { it <= Date.current }

    return nil if candidates.empty?

    candidates.max.to_s
  end

  # Misc

  # Match an icon according to the deduced category.
  # See `spritesheet.svg` for available SVG.
  def icon
    @icon ||= MerchantIcon.call(category)
  end

  def category
    @category ||= ExtractCategory.call(properties)
  end

  def geometry
    @feature['geometry']
  end

  def properties
    @feature['properties']
  end
end
