class SearchLog < ApplicationRecord
  belongs_to :category, optional: true

  validates :results_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Храним введенные ингредиенты текстом, чтобы история поиска не ломалась при переименовании или удалении справочника ингредиентов.
  def ingredient_list
    ingredient_names.to_s.split(",").map(&:strip).compact_blank
  end
end
