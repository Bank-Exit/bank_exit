class Directory < ApplicationRecord
  extend Mobility
  include WithCaptcha
  include WithLogoAndBanner
  include MobilityQueryable

  attribute :requested_by_user, :boolean, default: false
  attribute :proposition_from, :string

  captcha :nickname

  belongs_to :merchant, optional: true
  has_one :address, as: :addressable, dependent: :destroy
  has_many :coin_wallets, as: :walletable, dependent: :destroy
  has_many :contact_ways, as: :contactable, dependent: :destroy
  has_many :delivery_zones, as: :deliverable, dependent: :destroy
  has_many :weblinks, as: :weblinkable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  accepts_nested_attributes_for :address, reject_if: :all_blank
  accepts_nested_attributes_for :coin_wallets, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :contact_ways, allow_destroy: true
  accepts_nested_attributes_for :delivery_zones, allow_destroy: true
  accepts_nested_attributes_for :weblinks, allow_destroy: true

  translates :name, type: :string
  translates :description, type: :text
  queryable_by name: :string, description: :text

  positioned

  validates :name_en, presence: true
  validates :description_en, presence: true
  validates :category, presence: true, inclusion: { in: :allowed_categories }, if: :requested_by_user?
  validates :category, allow_blank: true, inclusion: { in: :allowed_categories }, unless: :requested_by_user?
  validates :proposition_from, allow_blank: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates_associated :coin_wallets
  validates_associated :contact_ways
  validates_associated :delivery_zones
  validates_associated :weblinks

  scope :by_position, -> { order(position: :asc) }
  scope :enabled, -> { where(enabled: true) }
  scope :disabled, -> { where(enabled: false) }
  scope :spotlights, -> { where(spotlight: true) }
  scope :by_category, ->(category) { where(category: category) }
  scope :by_coins, lambda { |coins|
    # Handle BTC onchain and Lightning in a similar way
    coins <<= 'lightning' if coins.include?('bitcoin')
    joins(:coin_wallets).where(coin_wallets: { coin: coins })
  }

  def allowed_categories
    I18n.t('directories_categories').keys.map(&:to_s)
  end

  def to_param
    [id, slug].join('-')
  end

  def slug
    name.parameterize
  end
end

# == Schema Information
#
# Table name: directories
# Database name: primary
#
#  id                 :integer          not null, primary key
#  name_legacy        :string
#  description_legacy :text
#  category           :string
#  spotlight          :boolean          default(FALSE), not null
#  enabled            :boolean          default(TRUE), not null
#  position           :integer          not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  merchant_id        :integer
#  comments_count     :integer          default(0), not null
#
# Indexes
#
#  index_directories_on_category     (category)
#  index_directories_on_merchant_id  (merchant_id)
#  index_directories_on_position     (position) UNIQUE
#
# Foreign Keys
#
#  merchant_id  (merchant_id => merchants.id)
#
