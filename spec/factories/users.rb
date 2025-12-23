# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    name { "Test User" }
    email { Faker::Internet.email }
    password { "password123" }

    trait :admin do
      role { :admin }
      school { nil }
    end

    trait :school_admin do
      role { :school_admin }
      association :school
    end

    trait :student do
      role { :student }
      association :school
    end
  end
end
