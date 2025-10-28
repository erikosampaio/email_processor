FactoryBot.define do
  factory :customer do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.phone_number }
    product_code { "PROD-#{Faker::Number.number(digits: 3)}" }
    subject { Faker::Lorem.sentence }
  end
end
