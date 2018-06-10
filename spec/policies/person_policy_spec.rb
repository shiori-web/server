require 'rails_helper'

RSpec.describe PersonPolicy do
  subject { PersonPolicy.new(user, person) }

  let(:person) { create(:person) }

  context 'for a visitor' do
    let(:user) { nil }

    it { is_expected.to permit(:index) }
    it { is_expected.to permit(:show) }

    it { is_expected.not_to permit(:create) }
    it { is_expected.not_to permit(:update) }
    it { is_expected.not_to permit(:destroy) }
  end

  context 'for a user' do
    let(:user) { create(:user) }

    it { is_expected.to permit(:index) }
    it { is_expected.to permit(:show) }

    it { is_expected.not_to permit(:create) }
    it { is_expected.not_to permit(:update) }
    it { is_expected.not_to permit(:destroy) }
  end

  context 'for an admin' do
    let(:user) { create(:admin) }

    it { is_expected.to permit(:index) }
    it { is_expected.to permit(:show) }

    it { is_expected.to permit(:create) }
    it { is_expected.to permit(:update) }
    it { is_expected.to permit(:destroy) }
  end
end
