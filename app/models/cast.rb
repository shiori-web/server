class Cast < ApplicationRecord
  enum locale: %i[en jp]
  enum role: %i[main support]

  belongs_to :anime
  belongs_to :person
  belongs_to :character

  validates_presence_of :role, :locale
end
