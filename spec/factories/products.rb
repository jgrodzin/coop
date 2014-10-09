# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product do
    name { Faker::Name.first_name }
    price { Faker::Commerce.price }
    description { Faker::Commerce.product_name }
    # vendor
  end
end
