class AddPayloadNostrToMerchantSync < ActiveRecord::Migration[8.1]
  def change
    add_column :merchant_syncs, :payload_nostr, :json, null: false, default: {}
  end
end
