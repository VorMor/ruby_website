class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_admin_user, :current_user, :user_signed_in?

  private

  def current_admin_user
    @current_admin_user ||= AdminUser.find_by(id: session[:admin_user_id], active: true)
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id], active: true)
  end

  def user_signed_in?
    current_user.present?
  end

  def require_user
    redirect_to login_path, alert: "Войдите, чтобы продолжить." unless current_user
  end
end
