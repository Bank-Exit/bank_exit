class AddMissingCoinsToMerchant < ActiveRecord::Migration[8.1]
  def change
    add_column :merchants, :silver, :boolean, null: false, default: false
    add_column :merchants, :gold, :boolean, null: false, default: false
  end
end
