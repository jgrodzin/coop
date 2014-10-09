# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    date { Faker::Date.forward(23) }
    # team
  end
end
