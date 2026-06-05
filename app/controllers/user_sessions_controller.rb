class UserSessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email].to_s.strip.downcase, active: true)

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to account_root_path, notice: "Вы вошли в личный кабинет."
    else
      flash.now[:alert] = "Неверная почта или пароль."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path, notice: "Вы вышли из аккаунта."
  end
end
