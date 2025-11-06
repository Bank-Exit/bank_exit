class EcosystemItem < ApplicationRecord
  extend Mobility

  attr_accessor :remove_picture

  translates :name, type: :string
  translates :description, type: :text

  has_one_attached :picture do |attachable|
    attachable.variant :small, resize_to_limit: [200, 200]
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end

  validates :name_en, presence: true
  validates :description_en, presence: true

  before_save :purge_picture_if_requested

  scope :enabled, -> { where(enabled: true) }

  private

  def purge_picture_if_requested
    picture.purge if ActiveModel::Type::Boolean.new.cast(remove_picture)
  end
end

# == Schema Information
#
# Table name: ecosystem_items
# Database name: primary
#
#  id         :integer          not null, primary key
#  url        :string
#  enabled    :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
