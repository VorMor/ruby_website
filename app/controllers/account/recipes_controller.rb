module Account
  class RecipesController < BaseController
    before_action :set_recipe, only: %i[edit update destroy]

    def index
      @recipes = current_user.recipes.includes(:category).recent
    end

    def new
      @recipe = current_user.recipes.new(default_recipe_attributes)
    end

    def create
      @recipe = current_user.recipes.new(recipe_params.merge(published: true))

      if save_with_ingredients
        redirect_to account_recipes_path, notice: "Рецепт создан."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      @recipe.assign_attributes(recipe_params)

      if save_with_ingredients
        redirect_to account_recipes_path, notice: "Рецепт обновлен."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @recipe.destroy!
      redirect_to account_recipes_path, notice: "Рецепт удален."
    end

    private

    def set_recipe
      @recipe = current_user.recipes.find_by!(slug: params[:id])
    end

    def default_recipe_attributes
      { published: true, difficulty: "medium", servings: 2 }
    end

    def recipe_params
      params.require(:recipe).permit(:title, :description, :instructions, :cooking_time, :servings, :difficulty, :image_url, :category_id)
    end

    def ingredients_text
      params.dig(:recipe, :ingredients_text)
    end

    # Рецепт и его состав сохраняются одной транзакцией, чтобы форма не оставляла неполные данные.
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
end
