require "test_helper"

class AdminUserTest < ActiveSupport::TestCase
  test "ensure default admin creates usable account" do
    AdminUser.delete_all

    admin = AdminUser.ensure_default_admin!

    assert_equal "admin@example.ru", admin.email
    assert admin.active?
    assert admin.authenticate("password123")
  end
end
