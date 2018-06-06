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
      render json: @user, serializer: serializer
    end

    def update
      authorize @user, :update?
      @user.update_attributes!(permitted_attributes(@user))
      render json: @user, serializer: serializer
    end

    def destroy
      authorize @user, :destroy?
      @user.destroy
      render json: @user, serializer: serializer
    end

    private

    def find_user
      @user = policy_scope(User).find(params[:id])
    end

    def serializer
      if policy!(@user).owner?
        Users::OwnerSerializer
      else
        UserSerializer
      end
    end
  end
end
