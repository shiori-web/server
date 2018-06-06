class User < ApplicationRecord
  rolify

  has_many :access_grants,
    dependent: :destroy,
    foreign_key: :resource_owner_id,
    class_name: 'Doorkeeper::AccessGrant'

  has_many :access_tokens,
    dependent: :destroy,
    foreign_key: :resource_owner_id,
    class_name: 'Doorkeeper::AccessToken'

  validates_presence_of :name, :username, :email
  validates_uniqueness_of :username, :email
  validates_length_of :name, :username, maximum: 100
  validates :email, email: true

  before_save -> { self.email = email.downcase }

  def self.authenticate(identifier, password)
    user = self.where('username = :identifier OR email = :identifier', { identifier: identifier }).first
    user if user && BCrypt::Password.new(user.encrypted_password) == password && user.confirmed?
  end
end
