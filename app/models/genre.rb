class Genre < ApplicationRecord
  include Nameable

  has_many :categories, dependent: :destroy
  has_many :animes, through: :categories,
    source: :categorizable, source_type: 'Anime'
end
