FactoryBot.define do
  factory :company do
    sequence(:name) { |n| "Company #{n+1}" }
  end
end