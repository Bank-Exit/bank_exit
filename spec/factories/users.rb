FactoryBot.define do
  factory :user do
    sequence(:email) { |i| "#{role}#{i}@demo.test" }
    password { 'password' }
    password_confirmation { password }
    enabled { true }

    traits_for_enum :role

    trait :disabled do
      enabled { false }
    end
  end
end
