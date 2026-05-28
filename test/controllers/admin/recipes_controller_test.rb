require "test_helper"

class Admin::RecipesControllerTest < ActionDispatch::IntegrationTest
  setup do
    post admin_login_url, params: { email: "admin@example.ru", password: "secret123" }
  end

  test "can publish recipe from custom admin action" do
    patch publish_admin_recipe_url(recipes(:hidden_soup))

    assert_redirected_to admin_recipes_url
    assert recipes(:hidden_soup).reload.published?
  end
end
