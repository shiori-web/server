class User < ApplicationRecord
  include Uploadable

  attr_accessor :password, :redirect_url

  rolify

  has_many :access_grants,
    dependent: :destroy,
    foreign_key: :resource_owner_id,
    class_name: 'Doorkeeper::AccessGrant'

  has_many :access_tokens,
    dependent: :destroy,
    foreign_key: :resource_owner_id,
    class_name: 'Doorkeeper::AccessToken'

  uploadable_field :avatar, versions: {
    big: '100x100>',
    small: '40x40>'
  }

  validates :name,
    presence: true,
    length: { maximum: 100 }

  validates :email,
    email: true,
    presence: true,
    uniqueness: true

  validates :username,
    presence: true,
    uniqueness: true,
    length: { maximum: 100 }

  validates :password,
    length: { within: 5..100 },
    if: -> { password.present? }

  with_options if: -> { new_record? } do
    validates :password, presence: true
    validates :redirect_url, presence: true

    before_save :set_tokens
  end

  before_save if: -> { email_changed? } do
    self.email = email.downcase
  end

  after_commit on: :create do
    add_role(:member)
    send_confirm_email
  end

  def self.authenticate(username, password)
    user = self.where('username = :username OR email = :username', { username: username }).first
    user if user && BCrypt::Password.new(user.encrypted_password) == password && user.confirmed?
  end

  private

  def set_tokens
    self.confirm_token = new_confirm_token
    self.encrypted_password = BCrypt::Password.create(password)
  end

  def new_confirm_token
    loop do
      token = SecureRandom.uuid.gsub('-', '')
      break token unless User.exists?(confirm_token: token)
    end
  end

  def send_confirm_email
    opts = { user_id: id, redirect_url: redirect_url }
    UserMailer.with(opts).confirm_email.deliver_later
  end
end
