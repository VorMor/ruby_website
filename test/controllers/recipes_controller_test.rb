require "test_helper"

class RecipesControllerTest < ActionDispatch::IntegrationTest
  test "index renders public catalog" do
    get recipes_url

    assert_response :success
    assert_select "h1", text: /Найдите блюдо/
    assert_select ".recipe-card", count: 1
  end

  test "show renders published recipe" do
    get recipe_url(recipes(:porridge))

    assert_response :success
    assert_select "h1", text: recipes(:porridge).title
  end
end
