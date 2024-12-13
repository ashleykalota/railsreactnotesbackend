class ApplicationController < ActionController::API
  before_action :authenticate_user!  # Authenticate the user on every request by default
  before_action :set_current_user

  SECRET_KEY = ENV['JWT_SECRET_KEY'] || 'fallbackSecret'

  def set_current_user

    return if skipped_action?

    token = request.headers["Authorization"]&.split(" ")&.last

    if token
      decoded_token = decode_token(token)

      if decoded_token && decoded_token[:user_id]  # Ensure the decoded token contains user_id
        @current_user = User.find_by(id: decoded_token[:user_id])  # Safely find the user
      else
        render json: { error: 'Invalid token' }, status: :unauthorized
      end
    else
      render json: { error: 'Token missing' }, status: :unauthorized
    end
  end
  
  private

 def skipped_action?
  %w[users#create users#login].include?("#{controller_name}##{action_name}")
 end

  def current_user
    @current_user ||= User.find_by(id: decoded_token[:user_id]) if decoded_token
  end

  def encode_token(payload)
    JWT.encode(payload, SECRET_KEY, 'HS256')
  end

  def auth_header
    header = request.headers['Authorization']
    Rails.logger.warn("Authorization Header is missing") unless header
    header
  end    

  def decode_token(token)
    begin
      JWT.decode(token, SECRET_KEY, true, { algorithm: 'HS256' }).first
    rescue JWT::DecodeError => e
      Rails.logger.debug "Token decoding failed: #{e.message}"
      nil
    end
  end
  
  def authenticate_user!
    @user = logged_in_user
    render json: { error: 'Unauthorized' }, status: :unauthorized unless @user
  end

  def logged_in_user
    if decoded_token
      user_id = decoded_token[0]['user_id']
      User.find_by(id: user_id)
    else
      nil
    end
  end
end
