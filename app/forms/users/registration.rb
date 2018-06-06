module Users
  class Registration
    include ActiveModel::Model

    attr_accessor(
      :name, :username,
      :email, :password,
      :redirect_url
    )

    validates :redirect_url,
      presence: true

    validates :password,
      presence: true,
      length: { within: 5..100 }

    validates :name,
      presence: true,
      length: { maximum: 100 }

    validates :email,
      email: true,
      presence: true,
      active_model_uniqueness: { model: User }

    validates :username,
      presence: true,
      length: { maximum: 100 },
      active_model_uniqueness: { model: User }
  end
end
