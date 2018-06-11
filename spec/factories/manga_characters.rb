FactoryBot.define do
  factory :manga_character do
    role 'main'
    manga
    character
  end
end
