require 'rails_helper'

RSpec.describe UserPolicy do
  subject { UserPolicy.new(user, record) }

  let(:record) { create(:user) }

  context 'for a visitor' do
    let(:user) { nil }

    it { is_expected.to permit(:index) }
    it { is_expected.to permit(:show) }
    it { is_expected.to permit(:create) }

    it { is_expected.not_to permit(:update) }
    it { is_expected.not_to permit(:destroy) }
  end

  context 'for an owner' do
    let(:user) { record }

    it { is_expected.to permit(:index) }
    it { is_expected.to permit(:show) }
    it { is_expected.to permit(:create) }

    it { is_expected.to permit(:update) }
    it { is_expected.to permit(:destroy) }
  end
end
