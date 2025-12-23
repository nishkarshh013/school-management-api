# spec/factories/courses.rb
FactoryBot.define do
  factory :course do
    name { "Ruby on Rails" }
    association :school
  end
end
