require "test_helper"

class Api::RecipesControllerTest < ActionDispatch::IntegrationTest
  test "index returns json recipes" do
    get api_recipes_url(format: :json), params: { q: "каша" }

    assert_response :success
    assert_equal "Овсяная каша", response.parsed_body.first["title"]
  end

  test "create stores recipe" do
    assert_difference("Recipe.count", 1) do
      post api_recipes_url(format: :json), params: {
        recipe: {
          title: "Тестовый омлет",
          description: "Быстрый рецепт для теста.",
          instructions: "Смешать и приготовить.",
          cooking_time: 8,
          servings: 1,
          difficulty: "easy",
          category_id: categories(:breakfast).id,
          published: true
        }
      }
    end

    assert_response :created
  end
end
