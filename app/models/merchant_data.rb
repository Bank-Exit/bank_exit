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

      contact_session: social_networks_prefixer.contact_session,
      contact_signal: social_networks_prefixer.contact_signal,
      contact_matrix: social_networks_prefixer.contact_matrix,
      contact_jabber: social_networks_prefixer.contact_jabber,
      contact_telegram: social_networks_prefixer.contact_telegram,
      contact_facebook: social_networks_prefixer.contact_facebook,
      contact_instagram: social_networks_prefixer.contact_instagram,
      contact_twitter: social_networks_prefixer.contact_twitter,
      contact_youtube: social_networks_prefixer.contact_youtube,
      contact_tiktok: social_networks_prefixer.contact_tiktok,
      contact_linkedin: social_networks_prefixer.contact_linkedin,
      contact_tripadvisor: social_networks_prefixer.contact_tripadvisor,
      contact_odysee: social_networks_prefixer.contact_odysee,
      contact_crowdbunker: social_networks_prefixer.contact_crowdbunker,
      contact_francelibretv: social_networks_prefixer.contact_francelibretv,

      ask_kyc: ask_kyc?,

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
    properties['website'] || properties['contact:website']
  end

  def email
    properties['email'] || properties['contact:email']
  end

  def phone
    properties['phone'] || properties['contact:phone']
  end

  # Coins

  def coins
    [].tap do |array|
      array << 'bitcoin' if bitcoin?
      array << 'lightning' if lightning?
      array << 'monero' if monero?
      array << 'june' if june?
    end
  end

  def bitcoin?
    properties['currency:XBT'] == 'yes'
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

  # Social networks

  def social_networks_prefixer
    @social_networks_prefixer ||= SocialNetworksPrefixer.new(properties)
  end

  # KYC

  def ask_kyc?
    (properties['payment:kyc'] && properties['payment:kyc'] == 'yes') || false
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
    [
      properties['check_date'],
      properties['survey:date'],
      properties['survey:date:currency:XMR']
    ].compact_blank.max
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
