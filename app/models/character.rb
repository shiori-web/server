class Character < ApplicationRecord
  include Personal

  has_many :casts, dependent: :destroy
  has_many :people, through: :casts
end
