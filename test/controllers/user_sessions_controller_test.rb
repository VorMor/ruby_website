require "test_helper"

class UserSessionsControllerTest < ActionDispatch::IntegrationTest
  test "signs user in with valid credentials" do
    post login_url, params: { email: "anna@example.ru", password: "secret123" }

    assert_redirected_to account_root_url
    follow_redirect!
    assert_select "h1", text: users(:anna).full_name
  end

  test "rejects invalid password" do
    post login_url, params: { email: "anna@example.ru", password: "wrong" }

    assert_response :unprocessable_entity
    assert_select ".flash-alert", text: "Неверная почта или пароль."
  end
end
