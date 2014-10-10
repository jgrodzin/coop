FactoryGirl.define do
  factory :event_product do
    product
    event
  end

  factory :event do
    date { Faker::Date.forward(23) }
    # team
  end

  factory :member do
    email { Faker::Internet.email }
    password "password"
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    address { Faker::Address.street_address }
  end

  factory :product do
    name { Faker::Name.first_name }
    price { Faker::Commerce.price }
    description { Faker::Commerce.product_name }
    # vendor
  end

  factory :team_member do
    member
    leader false
  end

  factory :team do
    name { Faker::Commerce.department(2) }
    # event
  end

  factory :vendor do
    rep { Faker::Name.name }
    name { Faker::Company.name }
    category { Faker::Commerce.product_name }
    address { Faker::Address.street_address }
    payment "POD"
  end
end
