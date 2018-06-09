class Character < ApplicationRecord
  include Personal

  has_many :performers, dependent: :destroy
  has_many :casts, dependent: :destroy
end
