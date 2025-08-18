class RemoveNullValueForAskKycOnMerchant < ActiveRecord::Migration[8.0]
  def up
    change_column :merchants, :ask_kyc, :boolean, null: true
  end

  def down
    change_column :merchants, :ask_kyc, :boolean, null: false
  end
end
