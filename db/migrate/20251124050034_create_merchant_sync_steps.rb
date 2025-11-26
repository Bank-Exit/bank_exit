class CreateMerchantSyncSteps < ActiveRecord::Migration[8.1]
  def change
    create_table :merchant_sync_steps do |t|
      t.integer :step, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.json :payload_error, null: false, default: {}
      t.references :merchant_sync, null: false, foreign_key: true

      t.timestamps
    end
  end
end
