class MerchantProposal
  include ActiveModel::Model
  include ActiveModel::Attributes
  include WithCaptcha

  ALLOWED_COINS = %i[
    bitcoin monero june lightning
    contact_less gold silver
  ].freeze

  captcha :nickname

  attribute :name, :string
  attribute :description
  attribute :category, :string
  attribute :other_category, :string
  attribute :street, :string
  attribute :postcode, :string
  attribute :city, :string
  attribute :country, :string
  attribute :latitude, :string
  attribute :longitude, :string
  attribute :phone, :string
  attribute :email, :string
  attribute :website, :string
  attribute :opening_hours, :string

  attribute :delivery, :boolean, default: false
  attribute :delivery_zone, :string
  attribute :last_survey_on, :date
  attribute :proposition_from, :string

  attribute :coins, default: -> { [] }
  attribute :ask_kyc, :boolean

  attribute :contact_facebook, :string
  attribute :contact_twitter, :string
  attribute :contact_telegram, :string
  attribute :contact_signal, :string
  attribute :contact_session, :string
  attribute :contact_odysee, :string
  attribute :contact_crowdbunker, :string
  attribute :contact_francelibretv, :string
  attribute :contact_tripadvisor, :string
  attribute :contact_matrix, :string
  attribute :contact_jabber, :string
  attribute :contact_youtube, :string
  attribute :contact_linkedin, :string
  attribute :contact_instagram, :string
  attribute :contact_tiktok, :string

  validates :name, presence: true
  validates :street, presence: true
  validates :postcode, presence: true
  validates :city, presence: true
  validates :country, presence: true
  validates :category, presence: true, inclusion: { in: I18n.t('categories').keys.push(:other).map(&:to_s) }, allow_blank: false
  validates :other_category, presence: true, if: :other_category_selected?
  validates :description, presence: true
  validates :coins, presence: true, inclusion: { in: ALLOWED_COINS.map(&:to_s) }
  validates :proposition_from, allow_blank: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def other_category_selected?
    category == 'other'
  end

  def decorate
    MerchantProposalDecorator.new(self)
  end

  # Match model attributes to OSM keys
  def to_osm
    model = decorate

    extra_keys = {}
    properties = {
      name: name,
      category: other_category_selected? ? other_category : I18n.t(category, scope: 'categories', default: category),
      description: description&.squish
    }

    # Address and geolocation
    properties['addr:street'] = street if street
    properties['addr:postcode'] = postcode if postcode
    properties['addr:city'] = city if city

    if country
      properties['addr:country'] = country
      extra_keys['country'] = model.pretty_country
    end

    extra_keys['latitude'] = latitude if latitude
    extra_keys['longitude'] = longitude if longitude

    # Contact
    properties[:email] = email if email
    properties[:phone] = phone if phone
    properties[:website] = website if website
    properties[:opening_hours] = opening_hours if opening_hours

    # Coins
    if 'bitcoin'.in?(coins)
      properties['currency:XBT'] = 'yes'
      properties['payment:onchain'] = 'yes'
    end

    properties['currency:XMR'] = 'yes' if 'monero'.in?(coins)
    properties['currency:XG1'] = 'yes' if 'june'.in?(coins)

    properties['payment:lightning'] = 'yes' if 'lightning'.in?(coins)
    properties['payment:lightning_contactless'] = 'yes' if 'contact_less'.in?(coins)
    properties['payment:silver'] = 'yes' if 'silver'.in?(coins)
    properties['payment:gold'] = 'yes' if 'gold'.in?(coins)

    unless ask_kyc.nil?
      properties['payment:kyc'] = ask_kyc ? 'yes' : 'no'
    end

    # Social networks
    properties['contact:facebook'] = contact_facebook if contact_facebook
    properties['contact:twitter'] = contact_twitter if contact_twitter
    properties['contact:telegram'] = contact_telegram if contact_telegram
    properties['contact:signal'] = contact_signal if contact_signal
    properties['contact:session'] = contact_session if contact_session
    properties['contact:odysee'] = contact_odysee if contact_odysee
    properties['contact:crowdbunker'] = contact_crowdbunker if contact_crowdbunker
    properties['contact:francelibretv'] = contact_francelibretv if contact_francelibretv
    properties['contact:tripadvisor'] = contact_tripadvisor if contact_tripadvisor
    properties['contact:matrix'] = contact_matrix if contact_matrix
    properties['contact:jabber'] = contact_jabber if contact_jabber
    properties['contact:youtube'] = contact_youtube if contact_youtube
    properties['contact:linkedin'] = contact_linkedin if contact_linkedin
    properties['contact:instagram'] = contact_instagram if contact_instagram
    properties['contact:tiktok'] = contact_tiktok if contact_tiktok

    # Other
    properties[:delivery] = 'yes' if delivery
    properties[:delivery_zone] = delivery_zone if delivery_zone
    properties['survey:date'] = last_survey_on if last_survey_on

    properties[:_extra_keys] = extra_keys if extra_keys.present?

    properties.as_json.compact_blank
  end
end
