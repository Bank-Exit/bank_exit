class CreateAnnouncements < ActiveRecord::Migration[8.0]
  def change
    create_table :announcements do |t|
      t.string :title
      t.text :description
      t.string :locale
      t.integer :mode
      t.string :link_to_visit
      t.datetime :published_at
      t.datetime :unpublished_at
      t.boolean :enabled, null: false, default: true

      t.timestamps
    end
  end
end
