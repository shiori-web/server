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

  def fetchable_fields(all)
    all = all - %i[password redirect_url]
    owner? ? all : all - [:email]
  end

  def updatable_fields(all)
    all - [:redirect_url]
  end
end
