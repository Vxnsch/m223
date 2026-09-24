class ApplicationController < ActionController::Base
  include Pundit::Authorization

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_user
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def require_login
    redirect_to login_path unless current_user
  end

  def redirect_if_authenticated
    redirect_to pages_path if current_user
  end

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  def require_admin
    redirect_to root_path unless current_user&.admin?
  end

  def require_uploader
    redirect_to root_path unless current_user&.admin? || current_user&.uploader?
  end

  def user_not_authorized
    redirect_to pages_path, alert: "You are not allowed to perform this action."
  end
end
