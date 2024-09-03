class JsonWebToken
    SECRET_KEY = Rails.application.credentials.secret_key_base. to_s
  
    def self.encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, SECRET_KEY)
    end
  
    def self.decode(token)
      begin
        decoded = JWT.decode(token, SECRET_KEY)[0]
        HashWithIndifferentAccess.new(decoded)
      rescue JWT::DecodeError => e
        Rails.logger.error "JWT Decode Error: #{e.message}"
        nil
      rescue StandardError => e
        Rails.logger.error "Error decoding JWT: #{e.message}"
        nil
      end
    end
end
  