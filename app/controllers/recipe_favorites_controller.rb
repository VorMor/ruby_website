class RecipeFavoritesController < ApplicationController
  before_action :require_user
  before_action :set_recipe

  def create
    current_user.favorite_recipes.find_or_create_by!(recipe: @recipe)
    redirect_back fallback_location: recipe_path(@recipe), notice: "Рецепт добавлен в избранное."
  end

  def destroy
    current_user.favorite_recipes.find_by(recipe: @recipe)&.destroy!
    redirect_back fallback_location: recipe_path(@recipe), notice: "Рецепт удален из избранного."
  end

  private

  def set_recipe
    @recipe = Recipe.published.find_by!(slug: params[:recipe_id])
  end
end
