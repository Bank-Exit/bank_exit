FactoryBot.define do
  factory :merchant do
    identifier { SecureRandom.hex(10) }
    original_identifier { "node/#{identifier}" }
    sequence(:name) { |n| "Merchant ##{n}" }
    slug { name.parameterize }
    category { 'bakery' }
    coins { %w[bitcoin monero] }

    with_address

    trait :with_address do
      house_number { '1' }
      street { 'Foo' }
      postcode { 'Bar' }
      city { 'MyCity' }
      country { 'FR' }
      full_address { '1 Foo Bar - MyCity, FR' }
      continent_code { COUNTRY_TO_CONTINENT[country] }
    end

    trait :with_opening_hours do
      opening_hours { 'Mo-Su 09:00-21:00' }
    end

    trait :with_logo do
      logo { Rack::Test::UploadedFile.new('spec/fixtures/1x1.png', 'image/png') }
    end

    trait :with_banner do
      banner { Rack::Test::UploadedFile.new('spec/fixtures/1x1.png', 'image/png') }
    end

    trait :with_latlon do
      latitude { 1.1 }
      longitude { 2.2 }
    end

    trait :french_polynesia do
      latitude { 1.11 }
      longitude { 2.22 }
    end

    trait :guadeloupe do
      latitude { 1.12 }
      longitude { 2.23 }
    end

    trait :martinique do
      latitude { 1.13 }
      longitude { 2.24 }
    end

    trait :reunion do
      latitude { 1.14 }
      longitude { 2.25 }
    end

    trait :mayotte do
      latitude { 1.15 }
      longitude { 2.26 }
    end

    trait :with_geometry_polygon do
      geometry do
        {
          type: 'Polygon',
          coordinates: [
            [
              [7.7556551, 48.6221281]
            ]
          ]
        }
      end
    end

    trait :with_geometry_point do
      geometry do
        {
          type: 'Point',
          coordinates: [7.7556551, 48.6221281]
        }
      end
    end

    trait :deleted do
      deleted_at { 1.minute.ago }
    end

    trait :with_all_contacts do
      contact_session { 'foobar' }
      contact_signal { 'foobar' }
      contact_matrix { 'foobar' }
      contact_jabber { 'foobar' }
      contact_telegram { 'foobar' }
      contact_facebook { 'foobar' }
      contact_instagram { 'foobar' }
      contact_twitter { 'foobar' }
      contact_youtube { 'foobar' }
      contact_tiktok { 'foobar' }
      contact_linkedin { 'foobar' }
      contact_tripadvisor { 'foobar' }
      contact_odysee { 'foobar' }
      contact_crowdbunker { 'foobar' }
      contact_francelibretv { 'foobar' }
    end
  end
end
