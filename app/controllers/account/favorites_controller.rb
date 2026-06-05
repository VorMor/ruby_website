module Account
  class FavoritesController < BaseController
    def index
      @recipes = current_user.favorite_recipe_items.includes(:category, :user).published.recent
    end
  end
end
