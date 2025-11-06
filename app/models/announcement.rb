class Announcement < ApplicationRecord
  extend Mobility

  enum :mode,
       { default: 0, info: 1, success: 2, warning: 3, error: 4 },
       default: :default,
       validate: true

  attr_accessor :remove_picture

  has_one_attached :picture do |attachable|
    attachable.variant :small, resize_to_limit: [200, 200]
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end

  translates :title, type: :string
  translates :description, type: :text
  translates :link_to_visit, type: :string, fallbacks: false

  validates :title_en, presence: true
  validates :description_en, presence: true
  validates :picture,
            content_type: {
              in: ['image/png', 'image/jpeg'],
              spoofing_protection: true
            },
            size: { less_than: 1.megabyte }

  before_save :purge_picture_if_requested

  scope :enabled, -> { where(enabled: true) }
  scope :published, lambda {
    where(
      arel_table[:published_at].lteq(Time.current).or(
        arel_table[:published_at].eq(nil)
      )
    ).where(
      arel_table[:unpublished_at].gt(Time.current).or(
        arel_table[:unpublished_at].eq(nil)
      )
    )
  }

  def overpass?
    return false unless unpublished_at

    unpublished_at < Time.current
  end

  private

  def purge_picture_if_requested
    picture.purge if ActiveModel::Type::Boolean.new.cast(remove_picture)
  end
end

# == Schema Information
#
# Table name: announcements
# Database name: primary
#
#  id             :integer          not null, primary key
#  title          :string
#  description    :text
#  locale         :string
#  mode           :integer
#  link_to_visit  :string
#  published_at   :datetime
#  unpublished_at :datetime
#  enabled        :boolean          default(TRUE), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
