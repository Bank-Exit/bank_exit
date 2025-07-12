class Directory < ApplicationRecord
  include WithLogoAndBanner

  attribute :from_proposition, :boolean, default: false

  belongs_to :merchant, optional: true
  has_one :address, as: :addressable, dependent: :destroy
  has_many :coin_wallets, as: :walletable, dependent: :destroy
  has_many :contact_ways, as: :contactable, dependent: :destroy
  has_many :delivery_zones, as: :deliverable, dependent: :destroy
  has_many :weblinks, as: :weblinkable, dependent: :destroy

  accepts_nested_attributes_for :address, reject_if: :all_blank
  accepts_nested_attributes_for :coin_wallets, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :contact_ways, allow_destroy: true
  accepts_nested_attributes_for :delivery_zones, allow_destroy: true
  accepts_nested_attributes_for :weblinks, allow_destroy: true

  positioned

  validates :name, presence: true
  validates :category, presence: true, inclusion: { in: :allowed_categories }, if: :from_proposition?
  validates :category, allow_blank: true, inclusion: { in: :allowed_categories }, unless: :from_proposition?
  validates :description, presence: true, if: :from_proposition?
  validates_associated :coin_wallets
  validates_associated :contact_ways
  validates_associated :delivery_zones
  validates_associated :weblinks

  scope :by_position, -> { order(position: :asc) }
  scope :enabled, -> { where(enabled: true) }
  scope :disabled, -> { where(enabled: false) }
  scope :spotlights, -> { where(spotlight: true) }
  scope :by_category, ->(category) { where(category: category) }
  scope :by_query, lambda { |query|
    where('name LIKE :query', query: "%#{query}%")
      .or(where('description LIKE :query', query: "%#{query}%"))
  }
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
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  description :text
#  category    :string
#  spotlight   :boolean          default(FALSE), not null
#  enabled     :boolean          default(TRUE), not null
#  position    :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  merchant_id :integer
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
