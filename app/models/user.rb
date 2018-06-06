class User < ApplicationRecord
  validates_presence_of :name, :username, :email
  validates_uniqueness_of :username, :email
  validates_length_of :name, :username, maximum: 100
  validates :email, email: true

  before_save -> { self.email = email.downcase }
end
