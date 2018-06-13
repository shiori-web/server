class Staff < ApplicationRecord
  belongs_to :anime
  belongs_to :person

  validates_presence_of :role
end
