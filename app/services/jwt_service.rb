class JwtService
  def self.decode(token)
    # Assuming you are using a library like JWT gem for decoding
    begin
      JWT.decode(token, Rails.application.credentials.secret_key_base, true, algorithm: 'HS256')
    rescue JWT::DecodeError => e
      nil
    end
  end
end
