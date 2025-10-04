FactoryBot.define do
  factory :directory do
    I18n.available_locales.each do |locale|
      send("name_#{locale}") { "Title #{locale}" }
      send("description_#{locale}") { "Description #{locale}" }
    end

    category { :food }
  end
end
