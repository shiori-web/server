module Users
  class ActivationService
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def activate!
      if params[:token] && params[:redirect_to]
        user = User.find_by!(confirm_token: params[:token], confirmed: false)
        user.update_attributes!(confirm_token: nil, confirmed: true)
      else
        fail ActiveRecord::RecordNotFound
      end
    end
  end
end
