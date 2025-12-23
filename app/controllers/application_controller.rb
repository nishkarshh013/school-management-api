class ApplicationController < ActionController::API
  include Pundit::Authorization

  before_action :authenticate_request

  attr_reader :current_user

  rescue_from Pundit::NotAuthorizedError do
    render json: { error: "Forbidden" }, status: :forbidden
  end

  private

  def authenticate_request
    header = request&.headers['Authorization']
    token = header&.split(' ').last if header

    decoded = JsonWebToken.decode(token)
    @current_user = User.find_by(id: decoded[:user_id]) if decoded

    render json: {error: "Unauthorized"}, status: :unauthorized unless @current_user  
  end
end
