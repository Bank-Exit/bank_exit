FactoryBot.define do
  factory :directory do
    I18n.available_locales.each do |locale|
      send("name_#{locale}") { "Title #{locale}" }
      send("description_#{locale}") { "Description #{locale}" }
    end

    category { :food }

    trait :with_logo do
      logo { Rack::Test::UploadedFile.new('spec/fixtures/1x1.png', 'image/png') }
    end

    trait :with_banner do
      banner { Rack::Test::UploadedFile.new('spec/fixtures/1x1.png', 'image/png') }
    end
  end
end
