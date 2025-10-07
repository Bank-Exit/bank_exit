FactoryBot.define do
  factory :api_token do
    name { Faker::Name.name }

    enabled { true }

    trait :live do
      enabled { true }
      expired_at { nil }
    end
  end
end
