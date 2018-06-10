require 'rails_helper'

RSpec.describe Genre, type: :model do
  subject { build(:genre) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_most(100) }
end
