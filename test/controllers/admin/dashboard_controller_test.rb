require "test_helper"

class Admin::DashboardControllerTest < ActionDispatch::IntegrationTest
  test "redirects anonymous user to login" do
    get admin_root_url

    assert_redirected_to admin_login_url
  end

  test "renders dashboard after login" do
    post admin_login_url, params: { email: "admin@example.ru", password: "secret123" }
    get admin_root_url

    assert_response :success
    assert_select "h1", text: "Управление поисковиком рецептов"
  end
end
