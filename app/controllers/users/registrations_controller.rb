# Manages user Registrations
class Users::RegistrationsController < ApplicationController

  # Render the user registration form
  #
  # @return [void]
  def new
    # instantiates the User model here
    @user = User.new
  end

  # Saves the new resource to the database(persistent)
  #
  # @return [void]
  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = t('.signed_up_successfully', name: @user.name)
      redirect_to groups_path
    else
      render :new
    end
  end

  private

  # Strong parameters/ Whitelist the users parameters
  #
  # @return [ApplicationController::Parameters] params
  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

end
