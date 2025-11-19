class AddContactNostrToMerchants < ActiveRecord::Migration[8.1]
  def change
    add_column :merchants, :contact_nostr, :string
  end
end
