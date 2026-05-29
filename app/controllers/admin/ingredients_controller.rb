class Admin::IngredientsController < Admin::BaseController
  before_action :set_ingredient, only: %i[edit update destroy]

  def index
    @ingredients = Ingredient.order(:name)
  end

  def new
    @ingredient = Ingredient.new
  end

  def create
    @ingredient = Ingredient.new(ingredient_params)

    if @ingredient.save
      redirect_to admin_ingredients_path, notice: "Ингредиент создан."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @ingredient.update(ingredient_params)
      redirect_to admin_ingredients_path, notice: "Ингредиент обновлен."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @ingredient.destroy!
    redirect_to admin_ingredients_path, notice: "Ингредиент удален."
  end

  private

  def set_ingredient
    @ingredient = Ingredient.find_by!(slug: params[:id])
  end

  def ingredient_params
    params.require(:ingredient).permit(:name, :description)
  end
end
