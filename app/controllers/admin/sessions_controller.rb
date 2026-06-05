class Admin::SessionsController < ApplicationController
  layout "admin"

  def new
  end

  def create
    # В учебном development-окружении восстанавливаем тестового админа,
    # если БД была пересоздана без seed-данных.
    AdminUser.ensure_default_admin! if (Rails.env.development? || Rails.env.test?) && AdminUser.none?

    admin_user = AdminUser.find_by(email: params[:email].to_s.downcase.strip, active: true)

    if admin_user&.authenticate(params[:password])
      session[:admin_user_id] = admin_user.id
      redirect_to admin_root_path, notice: "Вы вошли в панель администратора."
    else
      flash.now[:alert] = "Неверная почта или пароль."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:admin_user_id)
    redirect_to root_path, notice: "Вы вышли из панели администратора."
  end
end
