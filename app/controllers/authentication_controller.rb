class AuthenticationController < ApplicationController
    def login
      @user = User.find_by_email(params[:email])

      if @user&.authenticate(params[:password])
        token = JsonWebToken.encode(user_id: @user.id)
        time = Time.now + 24.hours.to_i

        render json: { 
          token: token,
          message: "Login successful. Your access token has been issued.",
          exp: time.strftime("%d-%m-%Y %H:%M")
        }, status: :ok
      else
        render json: { error: 'Incorrect email or password.Please check and try again!' }, status: :forbidden
      end
    end


    def logout
      header = request.headers['Authorization']
      token = header.split(' ').last if header
      
      if token
        BlacklistToken.create!(token: token)  # Blacklist the token
        # head :no_content  # Respond with no content
        render json: { message: 'Logged out successfully' }, status: :ok
      else
        render json: { error: 'No token provided' }, status: :bad_request
      end
    end
    
end
  