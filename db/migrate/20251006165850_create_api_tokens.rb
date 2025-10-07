class CreateAPITokens < ActiveRecord::Migration[8.0]
  def change
    create_table :api_tokens do |t|
      t.string :name
      t.text :description
      t.string :token, null: false, index: { unique: true }
      t.integer :requests_count, null: false, default: 0
      t.boolean :enabled, null: false, default: false
      t.datetime :expired_at

      t.timestamps
    end
  end
end
