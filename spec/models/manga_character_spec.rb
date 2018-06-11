require 'rails_helper'

RSpec.describe MangaCharacter, type: :model do
  subject { build(:manga_character) }

  it { is_expected.to validate_presence_of(:role) }

  it { is_expected.to belong_to(:manga) }
  it { is_expected.to belong_to(:character) }
end
