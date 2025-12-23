# spec/factories/enrollments.rb
FactoryBot.define do
  factory :enrollment do
    association :batch
    association :student, factory: :user
  end
end
