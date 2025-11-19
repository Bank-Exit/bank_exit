class Merchant < ApplicationRecord
  include Deletable
  include WithLogoAndBanner

  attr_accessor :with_comments

  has_one :directory, dependent: :nullify
  has_many :comments, as: :commentable, dependent: :destroy

  scope :by_query, lambda { |query|
    where('merchants.name LIKE :query', query: "%#{query}%")
      .or(where('merchants.description LIKE :query', query: "%#{query}%"))
      .or(where('merchants.full_address LIKE :query', query: "%#{query}%"))
      .or(where('merchants.category LIKE :query', query: "%#{query}%"))
      .or(where(identifier: query))
  }

  scope :by_category, ->(category) { where(category: category) }
  scope :by_country, ->(country) { where(country: country) }
  scope :by_continent, ->(continent) { where(continent_code: continent) }
  scope :bitcoin, -> { where(bitcoin: true).or(where(lightning: true)).or(where(contact_less: true)) }
  scope :monero, -> { where(monero: true) }
  scope :june, -> { where(june: true) }
  scope :bitcoin_only, -> { where(monero: false, june: false) }

  scope :in_france, -> { where(country: %w[FR France]) }
  scope :no_kyc, -> { where(ask_kyc: false) }
  scope :not_atms, -> { where.not(category: :atm).or(where(category: nil)) }

  def to_param
    [identifier, slug].compact_blank.join('-')
  end

  def atm?
    category == 'atm'
  end

  def to_directory!
    directory = build_directory(
      name_en: name,
      description_en: description,
      name_fr: name,
      description_fr: description,
      enabled: false
    )

    directory.build_address(label: full_address) if full_address.present?

    if coins.present?
      coins.each do |coin|
        directory.coin_wallets.new(coin: coin)
      end
    end

    traditional_contacts.each do |name, value|
      directory.contact_ways.new(
        role: name, value: value
      )
    end

    social_links.each do |name, link|
      directory.contact_ways.new(
        role: name, value: link
      )
    end

    directory.save
    directory
  end

  def all_contacts
    traditional_contacts.merge(social_links)
  end

  private

  def traditional_contacts
    {
      phone: phone,
      email: email,
      website: website
    }.compact_blank
  end

  def social_links
    {
      session: contact_session,
      signal: contact_signal,
      matrix: contact_matrix,
      jabber: contact_jabber,
      telegram: contact_telegram,
      facebook: contact_facebook,
      instagram: contact_instagram,
      twitter: contact_twitter,
      youtube: contact_youtube,
      odysee: contact_odysee,
      crowdbunker: contact_crowdbunker,
      francelibretv: contact_francelibretv,
      tiktok: contact_tiktok,
      linkedin: contact_linkedin,
      tripadvisor: contact_tripadvisor,
      nostr: contact_nostr
    }.compact_blank
  end
end

# == Schema Information
#
# Table name: merchants
# Database name: primary
#
#  id                    :integer          not null, primary key
#  identifier            :string
#  original_identifier   :string
#  name                  :string
#  slug                  :string
#  description           :text
#  house_number          :string
#  street                :string
#  postcode              :string
#  city                  :string
#  country               :string
#  full_address          :string
#  website               :string
#  email                 :string
#  phone                 :string
#  coins                 :json             not null
#  bitcoin               :boolean          default(FALSE), not null
#  lightning             :boolean          default(FALSE), not null
#  monero                :boolean          default(FALSE), not null
#  june                  :boolean          default(FALSE), not null
#  contact_less          :boolean          default(FALSE), not null
#  icon                  :string           default("shop"), not null
#  category              :string
#  geometry              :json             not null
#  raw_feature           :json             not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  delivery              :boolean          default(FALSE), not null
#  delivery_zone         :string
#  opening_hours         :string
#  last_survey_on        :date
#  contact_session       :string
#  contact_signal        :string
#  contact_matrix        :string
#  contact_jabber        :string
#  contact_telegram      :string
#  contact_facebook      :string
#  contact_instagram     :string
#  contact_twitter       :string
#  contact_youtube       :string
#  contact_tiktok        :string
#  contact_linkedin      :string
#  contact_tripadvisor   :string
#  ask_kyc               :boolean
#  latitude              :float
#  longitude             :float
#  comments_count        :integer          default(0), not null
#  deleted_at            :datetime
#  contact_odysee        :string
#  contact_crowdbunker   :string
#  contact_francelibretv :string
#  continent_code        :string
#  contact_nostr         :string
#
# Indexes
#
#  index_merchants_on_bitcoin         (bitcoin)
#  index_merchants_on_category        (category)
#  index_merchants_on_continent_code  (continent_code)
#  index_merchants_on_country         (country)
#  index_merchants_on_description     (description)
#  index_merchants_on_full_address    (full_address)
#  index_merchants_on_identifier      (identifier) UNIQUE
#  index_merchants_on_june            (june)
#  index_merchants_on_lightning       (lightning)
#  index_merchants_on_monero          (monero)
#  index_merchants_on_name            (name)
#
