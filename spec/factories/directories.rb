FactoryBot.define do
  factory :directory do
    name { 'Foobar' }
    category { :food }
    description { 'Lorem ipsum dolor sit amet' }
  end
end
