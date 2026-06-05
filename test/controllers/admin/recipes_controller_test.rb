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

  test "can update user recipe ingredients" do
    patch admin_recipe_url(recipes(:porridge)), params: {
      recipe: {
        title: recipes(:porridge).title,
        description: recipes(:porridge).description,
        instructions: recipes(:porridge).instructions,
        cooking_time: recipes(:porridge).cooking_time,
        servings: recipes(:porridge).servings,
        difficulty: recipes(:porridge).difficulty,
        image_url: recipes(:porridge).image_url,
        published: recipes(:porridge).published,
        category_id: recipes(:porridge).category_id,
        user_id: users(:anna).id,
        ingredients_text: "курица | 250 | г"
      }
    }

    assert_redirected_to admin_recipes_url
    assert_equal [ "курица" ], recipes(:porridge).reload.ingredients.pluck(:name)
  end
end
