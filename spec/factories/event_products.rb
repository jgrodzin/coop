# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event_product do
    product
    event
  end
end
