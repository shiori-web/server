FactoryBot.define do
  factory :person do
    sequence(:name) { |n| "Person #{n+1}" }
    gender 'male'
  end
end
