class ApplicationController < ActionController::API
  before_action :authenticate_user!  # Authenticate the user on every request by default
  before_action :set_current_user

  def set_current_user
    token = request.headers["Authorization"]&.split(" ")&.last
    if token
      decoded_token = JwtService.decode(token)  # Assuming you have a JwtService for decoding the token
      @current_user = User.find(decoded_token[:user_id])
    end
  end

  def current_user
    @current_user
  end

  SECRET_KEY = ENV['JWT_SECRET_KEY'] || 'fallbackSecret'

  def encode_token(payload)
    JWT.encode(payload, SECRET_KEY, 'HS256')
  end

  def auth_header
    header = request.headers['Authorization']
    Rails.logger.warn("Authorization Header is missing") unless header
    header
  end    

  def decoded_token
    header = auth_header
    return unless header # Return nil if there is no header

    # Extract the token if the header is a string
    token = header.split(' ')[1] if header.is_a?(String)
    return unless token # Return nil if token extraction fails

    begin
      JWT.decode(token, SECRET_KEY, true, { algorithm: 'HS256' })
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
