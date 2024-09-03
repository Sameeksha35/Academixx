class ApplicationController < ActionController::API
    before_action :authorize_request
    attr_reader :current_user

    rescue_from CanCan::AccessDenied do |exception|
        render json: { error: "Access Denied: You do not have permission to perform this action." }, status: :forbidden
    end


    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  
    #not optimise working
    # def not_found
    #   render json: { error: 'not_found' },status: :not_found
    # end
      
    # def authorize_request 
    #     header = request.headers['Authorization']
        
    #     # Skip authorization only for the login path
    #     return if request.path.include?('/login')
        
    #     if header.nil?
    #         render json: { error: 'Authorization header is missing, or you are accessing as a guest with limited access to public courses only.' }, status: :unauthorized
    #       return
    #     end
      
    #     header = header.split(' ').last
    #     if BlacklistToken.exists?(token: header)
    #       render json: { error: 'Invalid token' }, status: :unauthorized
    #     else
    #       begin
    #         @decoded = JsonWebToken.decode(header)
    #         @current_user = User.find(@decoded[:user_id])
    #       rescue ActiveRecord::RecordNotFound => e
    #         render json: { errors: e.message }, status: :unauthorized
    #       rescue JWT::DecodeError => e
    #         render json: { errors: e.message }, status: :unauthorized
    #       end
    #     end
    # end

    # private

    # def record_not_found(exception)
    #   render json: { error: exception.message }, status: :not_found
    # end
    #not optimise working

    def authorize_request

      return if request.path.include?('/login')

      token = request.headers['Authorization']&.split(' ')&.last
      return render_unauthorized('Authorization header is missing, or you are accessing as a guest with limited access to public courses only.') unless token
      return render_unauthorized('Invalid token') if BlacklistToken.exists?(token: token)

      decode_token(token)
    end

    def decode_token(token)
      @decoded = JsonWebToken.decode(token)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render_unauthorized(e.message)
    rescue JWT::DecodeError => e
      render_unauthorized(e.message)
    end

    def render_unauthorized(message)
      render json: { error: message }, status: :unauthorized
    end

    def record_not_found(exception)
      render json: { error: exception.message }, status: :not_found
    end
end
  