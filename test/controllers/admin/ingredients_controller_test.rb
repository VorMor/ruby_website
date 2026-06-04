require "test_helper"

class Admin::IngredientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    post admin_login_url, params: { email: "admin@example.ru", password: "secret123" }
  end

  test "renders ingredients" do
    get admin_ingredients_url

    assert_response :success
    assert_select "h1", text: "Ингредиенты"
  end
end
