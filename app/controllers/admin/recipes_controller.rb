class Admin::RecipesController < Admin::BaseController
  before_action :set_recipe, only: %i[edit update destroy publish unpublish]

  def index
    @recipes = Recipe.includes(:category).order(created_at: :desc)
  end

  def new
    @recipe = Recipe.new(published: true, difficulty: "medium", servings: 2)
  end

  def create
    @recipe = Recipe.new(recipe_params)

    if @recipe.save
      redirect_to admin_recipes_path, notice: "Рецепт создан."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @recipe.update(recipe_params)
      redirect_to admin_recipes_path, notice: "Рецепт обновлен."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @recipe.destroy!
    redirect_to admin_recipes_path, notice: "Рецепт удален."
  end

  def publish
    @recipe.update!(published: true)
    redirect_to admin_recipes_path, notice: "Рецепт опубликован."
  end

  def unpublish
    @recipe.update!(published: false)
    redirect_to admin_recipes_path, notice: "Рецепт снят с публикации."
  end

  private

  def set_recipe
    @recipe = Recipe.find_by!(slug: params[:id])
  end

  def recipe_params
    params.require(:recipe).permit(:title, :description, :instructions, :cooking_time, :servings, :difficulty, :image_url, :published, :category_id)
  end
end
