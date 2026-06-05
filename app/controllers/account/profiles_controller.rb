module Account
  class ProfilesController < BaseController
    def show
      @recipes_count = current_user.recipes.count
      @favorites_count = current_user.favorite_recipes.count
    end
  end
end
