require 'rails_helper'

RSpec.describe Person, type: :model do
  subject { build(:person) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_most(100) }
end
