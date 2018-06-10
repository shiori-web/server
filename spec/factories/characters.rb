FactoryBot.define do
  factory :character do
    sequence(:name) { |n| "Character #{n+1}" }
    gender 'male'
  end
end
