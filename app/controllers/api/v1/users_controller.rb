class Api::V1::UsersController < ApplicationController
  before_action :authenticate_request

  def create
    user = User.new(user_params)
    authorize user
    user.save!
    render json: user, status: :created
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role, :school_id)
  end
end
