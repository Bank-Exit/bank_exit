class AddNotesToMerchantSyncs < ActiveRecord::Migration[8.1]
  def change
    add_column :merchant_syncs, :notes, :text
  end
end
