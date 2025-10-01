class CreateEcosystemItems < ActiveRecord::Migration[8.0]
  def change
    create_table :ecosystem_items do |t|
      t.string :url
      t.boolean :enabled, null: false, default: true

      t.timestamps
    end
  end
end
