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
end
