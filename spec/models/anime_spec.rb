require 'rails_helper'

RSpec.describe Anime, type: :model do
  subject(:anime) { build(:anime) }

  it { is_expected.to have_many(:tags) }
  it { is_expected.to have_many(:genres) }
  it { is_expected.to have_many(:characters) }
  it { is_expected.to have_many(:staffs) }
  it { is_expected.to have_many(:performers) }
  it { is_expected.to have_many(:producers) }
  it { is_expected.to have_many(:studios) }
  it { is_expected.to have_many(:licensors) }

  it { is_expected.to validate_presence_of(:titles) }
  it 'should validate titles contains english version' do
    anime.titles = { jp: 'JP title' }
    expect(anime).not_to be_valid
  end

  describe '#slug' do
    before { create(:anime, titles: { en_jp: 'Anime 1' }, show_type: 'TV') }
    context 'title collide' do
      subject { create(:anime, titles: { en_jp: 'Anime 1' }, started_at: '2018-01-01') }
      it 'should construct from title & year' do
        expect(subject.slug).to eq('anime-1-2018')
      end
    end
    context 'title collide & show_type is not TV' do
      subject { create(:anime, titles: { en_jp: 'Anime 1' }, show_type: 'OVA') }
      it 'should construct from title & show_type' do
        expect(subject.slug).to eq('anime-1-ova')
      end
    end
    context 'title & show_type collide' do
      before { create(:anime, titles: { en_jp: 'Anime 1' }, show_type: 'TV') }
      subject { create(:anime, titles: { en_jp: 'Anime 1' }, show_type: 'TV', started_at: '2018-01-01') }
      it 'should construct from title, show_type & year' do
        expect(subject.slug).to eq('anime-1-tv-2018')
      end
    end
  end

  describe '#season' do
    it 'should return correct season based on started date' do
      { winter: 1, spring: 4, summer: 7, fall: 10 }.each do |season, month|
        expect(build(:anime, started_at: "2018-#{month}-01").season).to eq(season)
      end
    end
  end

  describe '#season_year' do
    it 'should return correct year of season based on started date' do
      { 12 => 2019, 3 => 2018, 6 => 2018, 9 => 2018 }.each do |month, year|
        expect(build(:anime, started_at: "2018-#{month}-01").season_year).to eq(year)
      end
    end
  end
end
