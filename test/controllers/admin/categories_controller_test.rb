require "test_helper"

class Admin::CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    post admin_login_url, params: { email: "admin@example.ru", password: "secret123" }
  end

  test "renders categories" do
    get admin_categories_url

    assert_response :success
    assert_select "h1", text: "Категории"
  end
end
