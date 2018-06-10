require 'rails_helper'

RSpec.describe Staff, type: :model do
  subject { build(:staff) }

  it { is_expected.to validate_presence_of(:role) }
end
