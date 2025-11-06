class User < ApplicationRecord
  authenticates_with_sorcery!

  enum :role, {
    super_admin: 0,
    admin: 1,
    publisher: 2,
    moderator: 3
  }, validate: true

  normalizes :email, with: ->(e) { e.strip.downcase }

  encrypts :email, deterministic: true

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 8 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  scope :enabled, -> { where(enabled: true) }
end

# == Schema Information
#
# Table name: users
# Database name: primary
#
#  id               :integer          not null, primary key
#  email            :string           not null
#  crypted_password :string
#  salt             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  role             :integer          default("moderator"), not null
#  enabled          :boolean          default(FALSE), not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
