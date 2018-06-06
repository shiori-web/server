module Users
  class RegistrationService
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def register!
      validate!
      user = create_user!
      send_confirm_email(user)
    end

    private

    def validate!
      form = Users::Registration.new(params)
      fail ActiveRecord::RecordInvalid.new(form) unless form.valid?
    end

    def create_user!
      User.create!(
        name: params[:name],
        email: params[:email],
        username: params[:username],
        confirm_token: confirm_token,
        encrypted_password: encrypted_password
      )
    end

    def send_confirm_email(user)
      opts = { user_id: user.id, redirect_url: params[:redirect_url] }
      UserMailer.with(opts).confirm_email.deliver_later
      user
    end

    def encrypted_password
      BCrypt::Password.create(params[:password])
    end

    def confirm_token
      loop do
        token = SecureRandom.uuid.gsub('-', '')
        break token unless User.exists?(confirm_token: token)
      end
    end
  end
end
