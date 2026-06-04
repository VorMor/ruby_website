require "test_helper"

class RecipeTest < ActiveSupport::TestCase
  test "search finds recipe by russian title" do
    assert_includes Recipe.search("каша"), recipes(:porridge)
  end

  test "search finds recipe by ingredient from main query" do
    assert_includes Recipe.search("молоко"), recipes(:porridge)
  end

  test "recipe must have valid cooking time" do
    recipe = recipes(:porridge)
    recipe.cooking_time = 0

    assert_not recipe.valid?
  end
end
