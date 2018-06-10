FactoryBot.define do
  factory :anime do
    sequence(:titles) do |n|
      { en_jp: "#{Faker::Name.name} #{n+1}" }
    end
    started_at 1.day.ago
    ended_at 1.week.from_now
    show_type :TV
  end
end
