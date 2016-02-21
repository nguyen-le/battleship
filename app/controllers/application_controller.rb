class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :setup_errors

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def setup_errors
    @errors = []
  end
end
