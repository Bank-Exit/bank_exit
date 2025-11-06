class CoinWallet < ApplicationRecord
  enum :coin,
       {
         bitcoin: 0,
         monero: 1,
         june: 2,
         lightning: 3
       },
       validate: true

  belongs_to :walletable, polymorphic: true

  scope :enabled, -> { where(enabled: true) }

  validates :public_address, allow_blank: true, crypto_address: true

  def public_address_reduced
    "#{public_address.first(10)}...#{public_address.last(10)}"
  end

  def qrcodable?
    public_address.present?
  end
end

# == Schema Information
#
# Table name: coin_wallets
# Database name: primary
#
#  id              :integer          not null, primary key
#  coin            :integer
#  public_address  :string
#  enabled         :boolean          default(TRUE), not null
#  walletable_type :string           not null
#  walletable_id   :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_coin_wallets_on_walletable  (walletable_type,walletable_id)
#
