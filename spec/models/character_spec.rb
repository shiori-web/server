require 'rails_helper'

RSpec.describe Character, type: :model do
  subject { build(:character) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_most(100) }
end
