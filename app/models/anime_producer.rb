class AnimeProducer < ApplicationRecord
  enum role: %i[producer studio licensor]

  belongs_to :anime
  belongs_to :producer

  validates_presence_of :role
end
