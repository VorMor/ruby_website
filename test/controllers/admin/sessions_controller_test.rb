require "test_helper"

class Admin::SessionsControllerTest < ActionDispatch::IntegrationTest
  test "admin can login" do
    post admin_login_url, params: { email: "admin@example.ru", password: "secret123" }

    assert_redirected_to admin_root_url
  end

  test "development login restores missing default admin" do
    AdminUser.delete_all

    post admin_login_url, params: { email: "admin@example.ru", password: "password123" }

    assert_redirected_to admin_root_url
    assert_equal 1, AdminUser.count
  end
end
