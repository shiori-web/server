FactoryBot.define do
  factory :tag do
    sequence(:name) { |n| "Tag #{n+1}" }
  end
end
