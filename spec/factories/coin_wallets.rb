FactoryBot.define do
  factory :coin_wallet do
    enabled { true }

    bitcoin

    association :walletable, factory: :directory

    trait :bitcoin do
      coin { :bitcoin }
      public_address { generate(:bitcoin_address) }
    end

    trait :lightning do
      coin { :lightning }
      public_address { generate(:lightning_invoice) }
    end

    trait :monero do
      coin { :monero }
      public_address { generate(:monero_address) }
    end

    trait :june do
      coin { :june }
      public_address { generate(:june_key) }
    end

    coin { :bitcoin }
  end

  sequence :bitcoin_address do |n|
    # Starts with bc1, followed by 25 to 39 base58 chars (excluding I,O,l)
    "bc1q#{SecureRandom.base58(25 + (n % 15))}"
  end

  sequence :lightning_invoice do |n|
    # Starts with lnbc, followed by 10+ alphanumeric characters
    "lnbc#{SecureRandom.alphanumeric(10 + (n % 10))}"
  end

  sequence :monero_address do |_n|
    # Monero address simplified: starts with 4 + 93 base58 characters
    # This is a simplified approximation matching the regex pattern
    "4#{SecureRandom.base58(94)}"
  end

  sequence :june_key do |n|
    # 42 to 55 alphanumeric characters, here generating length between 42 and 55
    SecureRandom.alphanumeric(42 + (n % 14))
  end
end
