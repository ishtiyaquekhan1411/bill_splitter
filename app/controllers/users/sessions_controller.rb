# Manages the User login and logout operations
class Users::SessionsController < ApplicationController

  before_action :check_login, except: :destroy

  # Renders the Login form
  #
  # @return [void]
  def new; end

  # Creates a new session with the user_id
  #
  # @return [void]
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:notice] = t('.logged_in_successfully')
      redirect_to groups_path
    else
      flash[:alert] = t('.unable_to_login')
      render :new
    end
  end

  # Logs out the user from session / destroys the session
  #
  # @return [void]
  def destroy
    logout! if logged_in?
    flash[:success] = t('.signed_out')
    redirect_to root_path
  end

  private

  # Whitelist the parameters extracted from the parameters
  #
  # @return [ApplicationController::Parameters] params
  def user_params
    params.require(:session).permit(:email, :password)
  end

  # Verifies if user is already logged in.
  def check_login
    if logged_in?
      flash[:alert] = t('.account_already_logged_in')
      redirect_to root_path
    end
  end

  # Destroys the session of user.
  #
  # @return [void]
  def logout!
    session[:user_id] = nil
  end

end
