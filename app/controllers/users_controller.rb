class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to account_root_path, notice: "Регистрация завершена. Добро пожаловать!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
    @recipes = @user.recipes.published.includes(:category).recent
  end

  private

  def user_params
    params.require(:user).permit(:email, :full_name, :bio, :password, :password_confirmation)
  end
end
