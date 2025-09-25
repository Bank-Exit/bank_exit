FactoryBot.define do
  factory :announcement do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    locale { I18n.default_locale }
    enabled { true }

    traits_for_enum :mode
  end
end
