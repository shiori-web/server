class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    true
  end

  def show?
    scope.where(id: record.id).exists?
  end

  def create?
    admin?
  end
  alias_method :update?, :create?
  alias_method :destroy?, :create?

  def owner?
    user&.id == record&.user_id
  end

  def admin?
    user&.has_role?(:admin)
  end

  def member?
    user&.has_role?(:member)
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
