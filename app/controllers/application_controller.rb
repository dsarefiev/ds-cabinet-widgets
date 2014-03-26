class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from Uas::Error, with: :user_error
  rescue_from Uas::NotAuthorized, with: :user_not_authorized

  protected

  def user_error
    render 'errors/user_error'
    allow_iframe
  end

  def user_not_authorized
    render 'errors/not_auth'
    allow_iframe
  end

  private

  def allow_iframe
    response.headers.delete 'X-Frame-Options'
  end

  # @return [Uas::User] currently logged in user
  def current_user
    token = request.cookies['auth_token']
    @current_user ||= Uas::User.find_by_token(token) if token
    rescue Uas::Error
      nil
  end

  helper_method :current_user

  # Add this method to before_action to authorize access.
  # @example before_filter :authorize
  def authorize
    raise Uas::NotAuthorized if current_user.nil?
  end
end
