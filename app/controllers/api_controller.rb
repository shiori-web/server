class ApiController < ActionController::API
  include Pundit
  include JSONAPI::Utils

  after_action :verify_authorized
  after_action :verify_policy_scoped

  rescue_from Pundit::NotAuthorizedError do
    jsonapi_render_errors UnauthorizedError.new, status: 403
  end

  rescue_from ActiveRecord::RecordNotFound do |ex|
    jsonapi_render_not_found ex
  end

  rescue_from ActiveRecord::RecordInvalid do |ex|
    jsonapi_render_errors json: ex.record, status: 422
  end

  def current_user
    @current_user ||= doorkeeper_token&.resource_owner
  end

  def authenticate_user!
    unless current_user
      jsonapi_render_errors UnauthenticatedError.new, status: 401
    end
  end

  def policy!(resource)
    ::Pundit.policy!(current_user, resource)
  end

  def context
    { user: current_user }
  end

  def apply_filter(records, opts)
    resource_klass.apply_filters(records, filter_params, context: context)
  end
end
