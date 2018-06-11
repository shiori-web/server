require 'rails_helper'

RSpec.describe Producer, type: :model do
  subject { build(:producer) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_most(100) }
end
