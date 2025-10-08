FactoryBot.define do
  factory :api_token do
    name { Faker::Name.name }

    enabled { true }

    trait :live do
      enabled { true }
      expired_at { nil }
    end

    trait :expired do
      expired_at { 1.day.ago }
    end
  end
end
