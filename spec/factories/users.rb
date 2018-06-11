FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "Name #{n+1}" }
    sequence(:username) { |n| "Username #{n+1}" }
    sequence(:email) { |n| "user#{n+1}@example.com" }
    password 'secret123'
    redirect_url 'http://localhost:3000'

    factory :admin do
      after(:create) do |user|
        user.add_role(:admin)
      end
    end
  end
end
