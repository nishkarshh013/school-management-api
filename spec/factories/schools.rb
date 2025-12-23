# spec/factories/schools.rb
FactoryBot.define do
  factory :school do
    name { "Test School" }
    address { "Test Address" }
  end
end
