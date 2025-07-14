class AddAttributesToUsers < ActiveRecord::Migration[8.0]
  def change
    change_table :users do |t|
      t.integer :role, null: false, default: 3
      t.boolean :enabled, null: false, default: false
    end
  end
end
