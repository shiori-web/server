FactoryBot.define do
  factory :producer do
    sequence(:name) { |n| "Producer #{n+1}" }
  end
end
