class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include StandardFailure

  if ENV["BASIC_AUTH_NAME"] && ENV["BASIC_AUTH_PASSWORD"]
    http_basic_authenticate_with name: ENV["BASIC_AUTH_NAME"], password: ENV["BASIC_AUTH_PASSWORD"]
  end

  def current_user
    @current_user ||= session[:current_user]
  end
  helper_method :current_user

  def admin_access?
    current_user == "admin"
  end
  helper_method :admin_access?

  def standard_access?
    current_user == "standard" || admin_access?
  end
  helper_method :standard_access?
end
