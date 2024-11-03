class ApplicationController < ActionController::API
  
  before_action :set_user
  before_action :authenticate_user!

  SECRET_KEY = ENV['JWT_SECRET_KEY'] || 'fallbackSecret'  # Make sure to keep this secret and secure

    def encode_token(payload)
      JWT.encode(payload, SECRET_KEY, 'HS256')
    end
  
    def auth_header
      auth_header = request.headers['Authorization']
      
      if auth_header.present?
        Rails.logger.debug "Authorization Header: #{auth_header}"
      else
        Rails.logger.warn "Authorization Header is missing"
      end
      
      auth_header
    end    
    
  
    def decoded_token
      return unless auth_header
    
      token = auth_header.split(' ')[1]  # Extract the token
      begin
        decoded_payload = JWT.decode(token, SECRET_KEY, true, {algorithm: 'HS256'})  # Use SECRET_KEY
        return decoded_payload
      rescue JWT::DecodeError => e
        Rails.logger.debug "Token decoding failed: #{e.message}"
        nil
      end
    end
    

    def authenticate_user!
      render json: { error: 'Unauthorized' }, status: :unauthorized unless logged_in?
    end
    
  
    def logged_in_user
      if decoded_token
        user_id = decoded_token[0]['user_id']  # Access the user_id from the payload
        @user = User.find_by(id: user_id)  # Find the user by ID
      end
    end
  
    def logged_in?
      !!logged_in_user  # Check if the user is logged in
    end
  
    private
  
    def set_user
      @user = logged_in_user  # Set the user based on token
    end
  
    def test_token_generation
      payload = { user_id: 1, exp: Time.now.to_i + 4 * 3600 }  # Example user ID
      token = encode_token(payload)
      Rails.logger.debug "Generated Token: #{token}"
      
      render json: { token: token }, status: :ok
    end
    
  end 