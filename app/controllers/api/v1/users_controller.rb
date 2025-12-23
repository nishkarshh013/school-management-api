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
    permitted = %i[name email password password_confirmation]

    if current_user&.admin?
      permitted += %i[role school_id]
    elsif current_user&.school_admin?
      permitted << :role
    end

    params.require(:user).permit(permitted)
  end
end
