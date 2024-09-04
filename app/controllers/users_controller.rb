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
