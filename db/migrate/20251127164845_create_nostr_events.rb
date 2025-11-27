class CreateNostrEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :nostr_events do |t|
      t.string :identifier, null: false, index: { unique: true }
      t.string :event_identifier, index: { unique: true }
      t.json :payload_event, null: false, default: {}
      t.json :payload_response, null: false, default: {}
      t.references :nostr_eventable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
