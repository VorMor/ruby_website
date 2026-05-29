class RecipesController < ApplicationController
  def index
    @categories = Category.order(:name)
    @recipes = RecipeSearch.new(params).call.includes(:category, :ingredients)

    log_search if search_params_present?
  end

  def show
    @recipe = Recipe.published.includes(recipe_ingredients: :ingredient).find_by!(slug: params[:id])
    @recipe.increment!(:views_count)
  end

  private

  def search_params_present?
    params.values_at(:q, :category_id, :ingredients, :max_time).any?(&:present?)
  end

  def log_search
    SearchLog.create!(
      query: params[:q],
      category_id: params[:category_id].presence,
      ingredient_names: params[:ingredients],
      results_count: @recipes.size,
      ip_address: request.remote_ip,
      user_agent: request.user_agent
    )
  end
end
