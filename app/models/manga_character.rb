class MangaCharacter < ApplicationRecord
  enum role: %i[main supporting]

  belongs_to :manga
  belongs_to :character

  validates_presence_of :role
end
