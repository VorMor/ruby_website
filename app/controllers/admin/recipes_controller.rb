class Admin::RecipesController < Admin::BaseController
  before_action :set_recipe, only: %i[edit update destroy publish unpublish]

  def index
    @recipes = Recipe.includes(:category, :user).order(created_at: :desc)
  end

  def new
    @recipe = Recipe.new(published: true, difficulty: "medium", servings: 2)
  end

  def create
    @recipe = Recipe.new(recipe_params)

    if save_with_ingredients
      redirect_to admin_recipes_path, notice: "Рецепт создан."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @recipe.assign_attributes(recipe_params)

    if save_with_ingredients
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
    params.require(:recipe).permit(:title, :description, :instructions, :cooking_time, :servings, :difficulty, :image_url, :published, :category_id, :user_id)
  end

  def ingredients_text
    params.dig(:recipe, :ingredients_text)
  end

  # Админская форма меняет и рецепт, и состав. Транзакция защищает от частичного сохранения.
  def save_with_ingredients
    Recipe.transaction do
      @recipe.save!
      @recipe.apply_ingredients_text!(ingredients_text)
    end

    true
  rescue ActiveRecord::RecordInvalid
    @recipe.ingredients_text = ingredients_text
    false
  end
end
