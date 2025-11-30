FactoryBot.define do
  factory :nostr_event do
    identifier { SecureRandom.uuid }

    association :nostr_eventable, factory: :merchant_sync
  end
end
