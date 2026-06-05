require "test_helper"

module Account
  class FavoritesControllerTest < ActionDispatch::IntegrationTest
    setup do
      post login_url, params: { email: "anna@example.ru", password: "secret123" }
      users(:anna).favorite_recipes.create!(recipe: recipes(:porridge))
    end

    test "shows user favorite recipes" do
      get account_favorites_url

      assert_response :success
      assert_select "h1", text: "Избранные рецепты"
      assert_select ".recipe-card", count: 1
    end
  end
end
