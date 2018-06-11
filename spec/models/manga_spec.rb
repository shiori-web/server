require 'rails_helper'

RSpec.describe Manga, type: :model do
  subject(:manga) { build(:manga) }

  it { is_expected.to have_many(:tags) }
  it { is_expected.to have_many(:genres) }
  it { is_expected.to have_many(:characters) }
  it { is_expected.to have_many(:manga_characters) }
  it { is_expected.to have_and_belong_to_many(:authors) }
  it { is_expected.to have_and_belong_to_many(:publishers) }

  it { is_expected.to validate_presence_of(:titles) }
  it { is_expected.to validate_presence_of(:subtype) }
  it 'should validate titles contains english version' do
    manga.titles = { jp: 'JP title' }
    expect(manga).not_to be_valid
  end

  describe '#slug' do
    before { create(:manga, titles: { en_jp: 'Manga 1' }) }
    context 'title collide' do
      subject { create(:manga, titles: { en_jp: 'Manga 1' }, subtype: 'novel') }
      it 'should construct from title & subtype' do
        expect(subject.slug).to eq('manga-1-novel')
      end
    end
    context 'title & subtype collide' do
      before { create(:manga, titles: { en_jp: 'Manga 1' }) }
      subject { create(:manga, titles: { en_jp: 'Manga 1' }, started_at: '2018-01-01') }
      it 'should construct from title, subtype & year' do
        expect(subject.slug).to eq('manga-1-manga-2018')
      end
    end
  end
end
