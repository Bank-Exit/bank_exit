class ContactWay < ApplicationRecord
  enum :role,
       {
         email: 0,
         phone: 1,
         website: 2,
         twitter: 3,
         facebook: 4,
         instagram: 5,
         tiktok: 6,
         youtube: 7,
         odysee: 8,
         crowdbunker: 9,
         francelibretv: 10,
         session: 11,
         signal: 12,
         telegram: 13,
         substack: 14,
         matrix: 15,
         jabber: 16,
         linkedin: 17,
         tripadvisor: 18,
         simplex: 19,
         nostr: 20
       },
       validate: true,
       default: :website

  belongs_to :contactable, polymorphic: true

  scope :enabled, -> { where(enabled: true) }

  validates :value, presence: true
  validates :value,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            if: :email?
  validates :value, url: true, if: :website?

  after_validation :prefix_social_networks, if: :social_network?

  private

  def prefix_social_networks
    self.value = prefixer.send("contact_#{role}").presence || value
  rescue StandardError
    nil
  end

  def prefixer
    SocialNetworksPrefixer.new(
      "contact:#{role}": value
    )
  end

  def social_network?
    !email? && !website? && !phone? && !substack? && !nostr?
  end
end

# == Schema Information
#
# Table name: contact_ways
#
#  id               :integer          not null, primary key
#  role             :integer
#  value            :string
#  enabled          :boolean          default(TRUE), not null
#  contactable_type :string           not null
#  contactable_id   :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_contact_ways_on_contactable  (contactable_type,contactable_id)
#
