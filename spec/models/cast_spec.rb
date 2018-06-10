require 'rails_helper'

RSpec.describe Cast, type: :model do
  subject { build(:cast) }

  it { is_expected.to validate_presence_of(:locale) }
end
