class UsersController < ApplicationController
  before_action :authorized, only: [:auto_login]

  # REGISTER
  def create
    @user = User.new(user_params)
    if @user.save  # Using save instead of create to trigger validations
      token = encode_token({ user_id: @user.id })
      render json: { user: @user, token: token }
    else
      render json: { error: "Invalid username or password" }, status: :unprocessable_entity
    end
  end

  # LOGGING IN
  def login
    @user = User.find_by(username: params[:username])

    if @user && @user.authenticate(params[:password])
      token = encode_token({user_id: @user.id})
      render json: {user: @user, token: token}
    else
      render json: {error: "Invalid username or password"}
    end
  end


  def auto_login
    render json: @user
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :age)
  end

  def encode_token(payload)
    JWT.encode(payload, ENV['JWT_SECRET_KEY'])
  end

  def authorized
    header = request.headers['Authorization']
    if header
      token = header.split(' ')[1] 
      begin
        decoded = JWT.decode(token, ENV['JWT_SECRET_KEY'], true, { algorithm: 'HS256' })[0]
        @user = User.find(decoded['user_id'])
      rescue JWT::DecodeError
        render json: { message: 'Please log in' }, status: :unauthorized
      end
    else
      render json: { message: 'Please log in' }, status: :unauthorized
    end
  end
  
end
