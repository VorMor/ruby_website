class Admin::DashboardController < Admin::BaseController
  def index
    @recipes_count = Recipe.count
    @published_count = Recipe.published.count
    @categories_count = Category.count
    @ingredients_count = Ingredient.count
    @recent_searches = SearchLog.includes(:category).order(created_at: :desc).limit(8)
  end
end
