FactoryBot.define do
  factory :performer do
    character
    role 'Role 1'
    association :performable, factory: :anime
  end
end
