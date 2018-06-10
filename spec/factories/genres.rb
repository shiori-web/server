FactoryBot.define do
  factory :genre do
    sequence(:name) { |n| "Genre #{n+1}" }
  end
end
