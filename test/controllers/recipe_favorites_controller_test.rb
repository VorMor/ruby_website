require "test_helper"

class RecipeFavoritesControllerTest < ActionDispatch::IntegrationTest
  setup do
    post login_url, params: { email: "anna@example.ru", password: "secret123" }
  end

  test "adds and removes favorite recipe" do
    assert_difference("FavoriteRecipe.count", 1) do
      post recipe_favorite_url(recipes(:porridge))
    end

    assert_redirected_to recipe_url(recipes(:porridge))

    assert_difference("FavoriteRecipe.count", -1) do
      delete recipe_favorite_url(recipes(:porridge))
    end

    assert_redirected_to recipe_url(recipes(:porridge))
  end
end
