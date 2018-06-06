require_dependency 'doorkeeper/orm/active_record/access_token'

Doorkeeper.configure do
  orm :active_record

  resource_owner_authenticator do
    fail "Please configure doorkeeper resource_owner_authenticator block located in #{__FILE__}"
  end

  resource_owner_from_credentials do
    User.authenticate(params[:username], params[:password])
  end

  admin_authenticator do
    user = User.find_by(session[:user_id])
    (user && user.has_role?(:admin)) || redirect_to(root_url)
  end

  access_token_expires_in 1.month
  authorization_code_expires_in 10.minutes

  base_controller 'ApplicationController'

  use_refresh_token
  native_redirect_uri 'urn:ietf:wg:oauth:2.0:oob'
  grant_flows %w[authorization_code client_credentials password]

  realm 'Shiori'
end

Doorkeeper::AccessToken.class_eval do
  belongs_to :resource_owner,
    optional: true,
    class_name: 'User'
end
