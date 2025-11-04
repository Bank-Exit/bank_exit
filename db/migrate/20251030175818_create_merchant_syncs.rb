class CreateMerchantSyncs < ActiveRecord::Migration[8.0]
  def change
    create_table :merchant_syncs do |t|
      t.datetime :started_at
      t.datetime :ended_at
      t.integer :mode, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.integer :instigator, null: false, default: 0
      t.integer :added_merchants_count, null: false, default: 0
      t.integer :updated_merchants_count, null: false, default: 0
      t.integer :soft_deleted_merchants_count, null: false, default: 0
      t.json :payload_added_merchants, null: false, default: {}
      t.json :payload_before_updated_merchants, null: false, default: {}
      t.json :payload_updated_merchants, null: false, default: {}
      t.json :payload_soft_deleted_merchants, null: false, default: {}
      t.json :payload_countries, null: false, default: {}
      t.json :payload_error, null: false, default: {}
      t.json :process_logs, null: false, default: []

      t.timestamps
    end
  end
end
