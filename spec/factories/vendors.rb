# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :vendor do
    rep { Faker::Name.name }
    name { Faker::Company.name }
    category { Faker::Commerce.product_name }
    address { Faker::Address.street_address }
    payment "POD"
  end
end
