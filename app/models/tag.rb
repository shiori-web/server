class Tag < ApplicationRecord
  include Nameable

  has_many :taggings, dependent: :destroy
  has_many :animes, through: :taggings, source: :taggable, source_type: 'Anime'
end
