class UserResource < BaseResource
  attributes :name, :username,
    :email, :password, :redirect_url

  filter :self, apply: ->(records, _, opts) do
    current_user = opts[:context].try(:[], :user)
    current_user ? records.where(id: current_user.id) : records
  end
end
