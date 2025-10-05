FactoryBot.define do
  factory :ecosystem_item do
    I18n.available_locales.each do |locale|
      send("name_#{locale}") { "Name #{locale}" }
      send("description_#{locale}") { "Description #{locale}" }
    end

    enabled { true }
  end
end
