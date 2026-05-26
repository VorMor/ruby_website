class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient

  validates :ingredient_id, uniqueness: { scope: :recipe_id }
  validates :amount, numericality: { greater_than: 0 }, allow_nil: true
  validates :unit, length: { maximum: 30 }

  def amount_with_unit
    [ amount&.to_f&.then { |value| value == value.to_i ? value.to_i : value }, unit, note ].compact_blank.join(" ")
  end
end
