class Staff < ApplicationRecord
  belongs_to :anime
  belongs_to :person

  delegate :name, :avatar, :gender, :info, to: :person

  validates_presence_of :role
end
