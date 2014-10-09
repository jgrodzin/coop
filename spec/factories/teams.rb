# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :team do
    name { Faker::Commerce.department(2) }
    # event
  end
end
