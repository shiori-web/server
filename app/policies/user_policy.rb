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

  def fetchable_fields
    all = %i[name username email]
    owner? ? all : all - [:email]
  end

  def creatable_fields
    %i(
      name username email
      password redirect_url
    )
  end

  def updatable_fields
    creatable_fields - [:redirect_url]
  end
end
