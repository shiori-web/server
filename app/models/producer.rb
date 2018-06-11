class Producer < ApplicationRecord
  include Nameable

  has_many :anime_producers, dependent: :destroy
  has_many :animes, through: :anime_producers
end
