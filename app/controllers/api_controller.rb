class ApiController < ActionController::API
  include Pundit

  after_action :verify_authorized
  after_action :verify_policy_scoped

  rescue_from Pundit::NotAuthorizedError do
    render_error 403, '403 Forbidden!'
  end

  rescue_from ActiveRecord::RecordNotFound do
    render_error 404, '404 Not found!'
  end

  rescue_from ActiveRecord::RecordInvalid do |ex|
    render json: {
      code: 422,
      errors: ex.record.errors,
      full_messages: ex.record.errors.full_messages
    }, status: 422
  end

  def current_user
    @current_user ||= doorkeeper_token&.resource_owner
  end

  def authenticate_user!
    unless current_user
      render_error 401, '401 Unauthenticate!'
    end
  end

  def policy!(resource)
    ::Pundit.policy!(current_user, resource)
  end

  private

  def render_error(code, message)
    render json: { code: code, error: message }, status: code
  end
end
