FactoryBot.define do
  factory :merchant_sync do
    started_at { 2.days.ago }
    ended_at { 1.day.ago }

    traits_for_enum :status

    trait :with_payloads do
      added_merchants_count { 1 }
      updated_merchants_count { 1 }
      soft_deleted_merchants_count { 1 }

      payload_added_merchants { { foo: 'bar' } }
      payload_before_updated_merchants { { foo: 'bar' } }
      payload_updated_merchants { { foo: 'bar2' } }
      payload_soft_deleted_merchants { { foo2: 'bar' } }
      payload_countries { { foo3: 'bar' } }
      process_logs { [{ mode: :info, message: 'info', timestamp: Time.current.to_i }, { mode: :success, message: 'success', timestamp: Time.current.to_i }, { mode: :error, message: 'errorr', timestamp: Time.current.to_i }] }
    end
  end
end
