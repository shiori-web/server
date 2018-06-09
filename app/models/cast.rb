class Cast < ApplicationRecord
  enum locale: %i[en jp]

  belongs_to :person
  belongs_to :character

  delegate :name, :avatar, :gender, :info, to: :person

  validates_presence_of :locale
end
