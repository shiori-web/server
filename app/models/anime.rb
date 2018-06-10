class Anime < ApplicationRecord
  include Media
  include AgeRatings
  include Uploadable

  enum show_type: %i[NA TV Movie OVA ONA Special Music]

  has_many :producers, dependent: :destroy
  has_many :studios, dependent: :destroy
  has_many :licensors, dependent: :destroy
  has_many :performers, as: :performable, dependent: :destroy
  has_many :characters, through: :performers
  has_many :staffs, dependent: :destroy

  uploadable_field :cover, versions: {
    small: '225x320>'
  }

  def status
    if started_at.nil?
      :TBA
    elsif started_at.future?
      :Upcoming
    elsif ended_at.nil? || ended_at.future?
      :Ongoing
    else
      :Finished
    end
  end

  private

  def slug_candidates
    candidates = [ -> { title } ]
    if show_type == 'TV'
      candidates << -> { [title, year] }
    else
      candidates << -> { [title, show_type] }
    end
    candidates << -> { [title, show_type, year] }
    candidates
  end
end
