class Performer < ApplicationRecord
  belongs_to :character
  belongs_to :performable, polymorphic: true

  delegate :name, :avatar, :gender, :info, :casts, to: :character
end
