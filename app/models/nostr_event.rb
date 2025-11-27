class NostrEvent < ApplicationRecord
  belongs_to :nostr_eventable, polymorphic: true
end

# == Schema Information
#
# Table name: nostr_events
# Database name: primary
#
#  id                   :integer          not null, primary key
#  identifier           :string           not null
#  event_identifier     :string
#  payload_event        :json             not null
#  payload_response     :json             not null
#  nostr_eventable_type :string           not null
#  nostr_eventable_id   :integer          not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_nostr_events_on_event_identifier  (event_identifier) UNIQUE
#  index_nostr_events_on_identifier        (identifier) UNIQUE
#  index_nostr_events_on_nostr_eventable   (nostr_eventable_type,nostr_eventable_id)
#
