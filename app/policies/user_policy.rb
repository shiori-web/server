class UserPolicy < ApplicationPolicy
  def create?
    true
  end

  def update?
    owner? || admin?
  end
  alias_method :destroy?, :update?

  def owner?
    user&.id == record&.id
  end

  def permitted_attributes
    %i(
      name username email
      password redirect_url
    )
  end
end
