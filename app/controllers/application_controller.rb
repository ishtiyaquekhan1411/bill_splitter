# frozen_string_literal: true

# Manages core functionality of rails.
class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  # Verifies if user is logged in.
  def logged_in?
    !!current_user
  end

  # Logged in <tt>User</tt> with the help of session.
  #
  # @return [User]
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  # Notifies user to log in before accessing URL or performing any operation.
  #
  # @return [void]
  def require_user
    unless logged_in?
      flash[:alert] = t('.general.logged_in_required')
      redirect_to users_login_path
    end
  end

end

