class UsersController < ApiController
  before_action :find_user, except: [:create, :index]

  def index
    authorize scope, :index?

    users = scope.all
    jsonapi_render json: users
  end

  def create
    authorize User, :create?
    user = Users::RegistrationService.new(resource_params).register!

    skip_policy_scope
    jsonapi_render json: user
  end

  def show
    authorize @user, :show?
    jsonapi_render json: @user
  end

  def update
    authorize @user, :update?
    @user.update_attributes!(resource_params)
    jsonapi_render json: @user
  end

  def destroy
    authorize @user, :destroy?
    @user.destroy
    jsonapi_render json: @user
  end

  private

  def find_user
    @user = scope.find(params[:id])
  end

  def scope
    policy_scope(User)
  end
end
