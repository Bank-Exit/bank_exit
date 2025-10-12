class APIToken < ApplicationRecord
  has_secure_token :token

  validates :name, presence: true
  validates :token, presence: true, uniqueness: true

  def live?
    enabled? && available?
  end

  def available?
    !expired?
  end

  def expired?
    return false unless expired_at

    expired_at < Time.current
  end
end

# == Schema Information
#
# Table name: api_tokens
#
#  id             :integer          not null, primary key
#  name           :string
#  description    :text
#  token          :string           not null
#  requests_count :integer          default(0), not null
#  enabled        :boolean          default(FALSE), not null
#  expired_at     :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_api_tokens_on_token  (token) UNIQUE
#
