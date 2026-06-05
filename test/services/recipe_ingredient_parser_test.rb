require "test_helper"

class RecipeIngredientParserTest < ActiveSupport::TestCase
  test "parses russian ingredient lines" do
    rows = RecipeIngredientParser.new("курица | 400,5 | г | филе\nсоль").rows

    assert_equal 2, rows.size
    assert_equal "курица", rows.first[:name]
    assert_equal BigDecimal("400.5"), rows.first[:amount]
    assert_equal "г", rows.first[:unit]
    assert_equal "филе", rows.first[:note]
    assert_equal "соль", rows.second[:name]
  end
end
