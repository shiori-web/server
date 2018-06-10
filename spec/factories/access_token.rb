FactoryBot.define do
  factory :access_token, class: Doorkeeper::AccessToken do
    association :resource_owner, factory: :user
  end
end
