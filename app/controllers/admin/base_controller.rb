module Admin
  class BaseController < ApplicationController
    before_action :require_admin_user
    layout "admin"

    private

    def require_admin_user
      redirect_to admin_login_path, alert: "Войдите в панель администратора." unless current_admin_user
    end
  end
end
