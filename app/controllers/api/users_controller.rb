module Api
  class UsersController < ::ApiController
    before_action :find_user, except: [:create, :index]

    def create
      authorize User, :create?
      user = Users::RegistrationService.new(permitted_attributes(User)).register!

      skip_policy_scope
      render json: user, serializer: Users::OwnerSerializer
    end

    def show
      authorize @user, :show?

      if policy!(@user).owner?
        serializer = Users::OwnerSerializer
      else
        serializer = UserSerializer
      end

      render json: @user, serializer: serializer
    end

    private

    def find_user
      @user = policy_scope(User).find(params[:id])
    end
  end
end
