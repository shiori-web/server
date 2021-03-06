class BaseResource < JSONAPI::Resource
  include SearchableResource
  include JSONAPI::Authorization::PunditScopedResource

  abstract

  class << self
    def policy!(user, record)
      ::Pundit.policy(user, record)
    end

    def creatable_fields(context)
      policy!(context[:user], _model_class).try(:creatable_fields, super) || super
    end

    def updatable_fields(context)
      policy!(context[:user], _model_class).try(:updatable_fields, super) || super
    end
  end

  def policy!(user, record_or_class)
    self.class.policy!(context[:user], record_or_class)
  end

  def fetchable_fields
    policy!(context[:user], _model).try(:fetchable_fields, super) || super
  end
end
