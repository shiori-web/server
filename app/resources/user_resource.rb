class UserResource < BaseResource
  attributes :name, :username,
    :email, :password, :redirect_url

  # filter :name
end
