class Company < ApplicationRecord
  include Nameable

  has_many :producers, dependent: :destroy
  has_many :animes, through: :producers
end
