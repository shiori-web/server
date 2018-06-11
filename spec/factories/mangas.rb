FactoryBot.define do
  factory :manga do
    sequence(:titles) do |n|
      { en_jp: "#{Faker::Name.name} #{n+1}" }
    end
    subtype 'manga'
    started_at 1.day.ago
    ended_at 1.week.from_now
  end
end
