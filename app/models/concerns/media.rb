module Media
  extend ActiveSupport::Concern

  included do
    include Seasonal
    include Titleable
    include Sluggable

    has_many :categories, as: :categorizable, dependent: :destroy
    has_many :genres, through: :categories

    has_many :taggings, as: :taggable, dependent: :destroy
    has_many :tags, through: :taggings
  end

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
end
