class RegistrationsController < ApplicationController
  def show
    Users::ActivationService.new(params).activate!
    redirect_to params[:redirect_to]
  end
end
