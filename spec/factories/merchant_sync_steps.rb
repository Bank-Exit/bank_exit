FactoryBot.define do
  factory :merchant_sync_step do
    traits_for_enum :step
    traits_for_enum :status

    association :merchant_sync
  end
end
