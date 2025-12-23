# spec/factories/batch.rb
FactoryBot.define do
  factory :batch do
    name { "Ruby on Rails" }
    association :course
  end
end
