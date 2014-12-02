FactoryGirl.define do

  factory :cart_item do
    shopping_cart
    product
  end

  factory :inventory do
    product
    event
  end

  factory :event do
    date { Faker::Date.forward(23) }
    team
  end

  factory :member do
    email { Faker::Internet.email }
    password "password"
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    street_address { Faker::Address.street_address }
    unit_number { Faker::Address.secondary_address }
    city { Faker::Address.city }
    state { Faker::Address.state }
    zip { Faker::Address.zip_code }
    phone { Faker::PhoneNumber.phone_number }
  end

  factory :product do
    name { Faker::Name.first_name }
    price { Faker::Commerce.price }
    # description { Faker::Commerce.product_name }
    unit_type "each"
    vendor
  end

  factory :shopping_cart do
    member
    event

    trait :with_products do
      after(:create) do |shopping_cart|
        shopping_cart.products << FactoryGirl.create_list(:inventory, 10)
      end
    end
  end

  factory :team_member do
    member
    leader false
  end

  factory :team do
    name { Faker::Commerce.department(2) }
    sequence(:number)
  end

  factory :vendor do
    rep { Faker::Name.name }
    name { Faker::Company.name }
    category { Faker::Commerce.product_name }
    address { Faker::Address.street_address }
    payment "POD"

    trait :with_products do
      after(:create) do |vendor|
        vendor.products << FactoryGirl.create_list(:product, 10)
      end
    end
  end
end
