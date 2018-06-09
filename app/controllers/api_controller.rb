class ApiController < ActionController::API
  include Pundit
  include JSONAPI::Utils

  rescue_from ActiveRecord::RecordNotFound do |ex|
    fail JSONAPI::Exceptions::RecordNotFound.new('unspecified')
  end

  rescue_from Pundit::NotAuthorizedError do
    jsonapi_render_errors UnauthorizedError.new, status: 403
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
end
