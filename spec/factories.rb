FactoryGirl.define do
  factory :admin do
  end

  factory :cart_item do
    shopping_cart
    product
    amount 1
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
    admin false
  end

  factory :product do
    name { Faker::Name.first_name }
    price { rand(1..99) * 100 }
    unit_type "each"
    vendor
    event
  end

  factory :shopping_cart do
    member
    event
  end

  factory :team_member do
    member
    team
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
        vendor.products << FactoryGirl.create_list(:product, 10, vendor_id: vendor.id)
      end
    end
  end
end
