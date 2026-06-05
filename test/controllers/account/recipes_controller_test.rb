require "test_helper"

module Account
  class RecipesControllerTest < ActionDispatch::IntegrationTest
    setup do
      post login_url, params: { email: "anna@example.ru", password: "secret123" }
    end

    test "creates own recipe with ingredients" do
      assert_difference("Recipe.count", 1) do
        assert_difference("RecipeIngredient.count", 2) do
          post account_recipes_url, params: {
            recipe: recipe_params.merge(
              title: "Куриные котлеты",
              ingredients_text: "курица | 400 | г | фарш\nлук | 1 | шт"
            )
          }
        end
      end

      recipe = Recipe.find_by!(title: "Куриные котлеты")
      assert_equal users(:anna), recipe.user
      assert_equal [ "курица", "лук" ], recipe.ingredients.order(:name).pluck(:name)
      assert_redirected_to account_recipes_url
    end

    test "deletes own recipe" do
      assert_difference("Recipe.count", -1) do
        delete account_recipe_url(recipes(:porridge))
      end

      assert_redirected_to account_recipes_url
    end

    private

    def recipe_params
      {
        description: "Домашнее блюдо на каждый день.",
        instructions: "Смешать ингредиенты и приготовить до готовности.",
        cooking_time: 35,
        servings: 3,
        difficulty: "medium",
        image_url: "https://example.com/chicken.jpg",
        category_id: categories(:breakfast).id
      }
    end
  end
end
