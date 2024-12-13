class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create, :login]  # Skip authentication for signup and login
  skip_before_action :set_current_user, only: [:create, :login] 
  # REGISTER
  def create
    @user = User.new(user_params)
    if @user.save
      token = encode_token({ user_id: @user.id })
      render json: { user: @user, token: token }
    else
      Rails.logger.debug "User creation failed: #{@user.errors.full_messages}"
      render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  

  # LOGGING IN
  def login
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      token = encode_token({ user_id: @user.id })
      render json: { user: @user, token: token }
    else
      render json: { error: "Invalid username or password" }, status: :unauthorized
    end
  end

  def auto_login
    render json: @user
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :phone_number, :email, :role, :name)
  end
end
