require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "creates user account and signs in" do
    assert_difference("User.count", 1) do
      post users_url, params: {
        user: {
          full_name: "Тестовый Повар",
          email: "new-cook@example.ru",
          bio: "Готовлю ужины после работы.",
          password: "secret123",
          password_confirmation: "secret123"
        }
      }
    end

    assert_redirected_to account_root_url
    follow_redirect!
    assert_select "h1", text: "Тестовый Повар"
  end

  test "shows public user recipe page" do
    get user_url(users(:anna))

    assert_response :success
    assert_select "h1", text: users(:anna).full_name
    assert_select ".recipe-card", count: 1
  end
end
