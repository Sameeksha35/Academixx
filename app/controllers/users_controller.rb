#not optimise working
# # class UsersController < ApplicationController
# #     before_action :authorize_request, except: :create
# #     before_action :set_user, only: %i[show update destroy]
# #     # before_action :authorize_admin!, only: %i[index destroy]
# #     load_and_authorize_resource #added after admin testing
# #     
# #     def create
# #       @user = User.new(user_params)
# #       if @user.save
# #         # RegistrationEmailJob.perform_async(@user.id)
# #         @user.add_role(params[:role] || :student)
# #         if @user.has_role?(:student)
# #             UserMailer.registration_email(@user).deliver_later
# #         end
# #         render json: @user, status: :created
# #       else
# #         render json: @user.errors, status: :unprocessable_entity
# #       end
# #     end
  
# #     def index
# #       @users = User.includes(:roles).all # Fetch all users and their roles

# #       # Render JSON with roles as an array of strings
# #       render json: @users.map { |user| 
# #       {
# #         id: user.id,
# #         name: user.name,
# #         username: user.username,
# #         email: user.email,
# #         # created_at: user.created_at,
# #         # updated_at: user.updated_at,
# #         roles: user.roles.pluck(:name) # Extract role names as an array of strings
# #       }
# #       }
# #     end
  
# #     def show
# #       # render json: { @user ,roles: @user.roles.pluck(:name)}
# #       render json: {
# #       user: {
# #         id: @user.id,
# #         name: @user.name,
# #         username: @user.username,
# #         email: @user.email,
# #         # password_digest: @user.password_digest,
# #         roles: @user.roles.pluck(:name) # Fetches the names of the roles using Rolify
# #       }
# #     }
# #     end
  
# #     def update
# #       if @user.update(user_params)
# #         render json: @user
# #       else
# #         render json: @user.errors, status: :unprocessable_entity
# #       end
# #     end
  
# #     def destroy
# #       @user.destroy
# #       head :no_content
# #     end
  
# #     private
  
# #     def set_user
# #       @user = User.find(params[:id])
# #     rescue ActiveRecord::RecordNotFound
# #       render json: { error: 'User not found' }, status: :not_found
# #     end
  
# #     def user_params
# #       params.require(:user).permit(:name, :username, :email, :password, :password_confirmation)
# #     end


# #     def authorize_admin
# #       unless @current_user.has_role?(:admin)
# #         render json: { error: 'You are not authorized to perform this action' }, status: :unauthorized
# #       end
# #     end
# # end

# class UsersController < ApplicationController
#   before_action :authorize_request
#   before_action :set_user, only: %i[show update destroy]
#   load_and_authorize_resource 

#   def create
#     @user = User.new(user_params)
    
#     if @user.save
#       @user.add_role(params[:role] || :student)

#       begin
#         UserMailer.registration_email(@user).deliver_now if @user.has_role?(:student)#deliver_later
#       rescue Net::SMTPAuthenticationError => e
#         Rails.logger.error "Failed to send email: #{e.message}"
#       end

#       user_response = {
#         id: @user.id,
#         name: @user.name,
#         username: @user.username,
#         email: @user.email,
#         roles: @user.roles.pluck(:name), # roles are managed via Rolify
#         created_at: @user.created_at.strftime('%B %d, %Y'),
#         updated_at: @user.updated_at.strftime('%B %d, %Y')
#       }
#       render json: {
#         message: "User created successfully!",
#         user: user_response
#       }, status: :created
#     else
#       render json: {
#         message: "User creation failed.",
#         errors: @user.errors.full_messages
#       }, status: :unprocessable_entity
#     end
#   end

#   def index
#     @users = User.includes(:roles).all
  
#     render json: {
#       message: "List of all users retrieved successfully.",
#       total_users: @users.count,
#       users: @users.map { |user| user_data(user) }
#     }, status: :ok
#   end
  

#   def show
#     render json: {
#       message: "User details fetched successfully!",
#       user: user_data(@user)
#     }, status: :ok
#   end

#   def update
#     if @user.update(user_params)
#       render json: {
#         message: "User updated successfully!",
#         user: user_data(@user) #format user data, including roles
#       }, status: :ok
#     else
#       render json: { 
#         message: "Failed to update user.",
#         errors: @user.errors.full_messages 
#       }, status: :unprocessable_entity
#     end
#   end

#   def destroy
#     if @user.destroy
#       render json: { message: "User successfully deleted." }, status: :ok
#     else
#       render json: { error: "Failed to delete user. Please try again." }, status: :unprocessable_entity
#     end
#   end

#   private

#   def set_user
#     @user = User.find_by(id: params[:id])
#     render json: { error: 'User not found' }, status: :not_found unless @user
#   end

#   def user_params
#     params.require(:user).permit(:name, :username, :email, :password, :password_confirmation)
#   end
  
#   def user_data(user)
#     {
#       id: user.id,
#       name: user.name,
#       username: user.username,
#       email: user.email,
#       roles: user.roles.pluck(:name), 
#       created_at: user.created_at.strftime('%B %d, %Y'),
#       updated_at: user.updated_at.strftime('%B %d, %Y')
#     }
#   end
# end

#not optimise working

class UsersController < ApplicationController
  before_action :authorize_request#removed except create
  before_action :set_user, only: %i[show update destroy]
  load_and_authorize_resource

  def create
    if extra_params_present?
      render json: { error: "Unexpected parameters present" }, status: :unprocessable_entity
      return
    end
    @user = User.new(user_params)
    
    if @user.save
      @user.add_role(params[:role] || :student)

      begin
        UserMailer.registration_email(@user).deliver_now if @user.has_role?(:student)
      rescue Net::SMTPAuthenticationError => e
        Rails.logger.error "Failed to send email: #{e.message}"
      end

      render json: {
        message: "User created successfully!",
        user: user_data(@user)
      }, status: :created
    else
      render json: {
        message: "User creation failed.",
        errors: @user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def index
    @users = User.includes(:roles).all

    render json: {
      message: "List of all users retrieved successfully.",
      total_users: @users.count,
      users: @users.map { |user| user_data(user) }
    }, status: :ok
  end

  def show
    render json: {
      message: "User details fetched successfully!",
      user: user_data(@user)
    }, status: :ok
  end

  def update
    if extra_params_present?
      render json: { error: "Unexpected parameters present" }, status: :unprocessable_entity
      return
    end
    if @user.update(user_params)
      render json: {
        message: "User updated successfully!",
        user: user_data(@user)
      }, status: :ok
    else
      render json: {
        message: "Failed to update user.",
        errors: @user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      render json: {
        message: "User successfully deleted."
      }, status: :ok
    else
      render json: {
        error: "Failed to delete user. Please try again."
      }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
    render json: { error: 'User not found' }, status: :not_found unless @user
  end

  def user_params
    params.require(:user).permit(:name, :username, :email, :password, :password_confirmation)
  end

  def extra_params_present?
    permitted_keys = user_params.keys.map(&:to_s)
    extra_keys = params[:user].keys.map(&:to_s) - permitted_keys
    extra_keys.any?
  end
  

  def user_data(user)
    {
      id: user.id,
      name: user.name,
      username: user.username,
      email: user.email,
      roles: user.roles.pluck(:name), 
      created_at: user.created_at.strftime('%B %d, %Y'),
      updated_at: user.updated_at.strftime('%B %d, %Y')
    }
  end
end
