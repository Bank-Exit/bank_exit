class Weblink < ApplicationRecord
  belongs_to :weblinkable, polymorphic: true

  validates :url, presence: true, url: true

  scope :enabled, -> { where(enabled: true) }
end

# == Schema Information
#
# Table name: weblinks
# Database name: primary
#
#  id               :integer          not null, primary key
#  url              :string
#  title            :string
#  enabled          :boolean          default(TRUE), not null
#  weblinkable_type :string           not null
#  weblinkable_id   :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_weblinks_on_weblinkable  (weblinkable_type,weblinkable_id)
#
