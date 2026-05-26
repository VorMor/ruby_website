class Ingredient < ApplicationRecord
  include Sluggable

  has_many :recipe_ingredients, dependent: :destroy
  has_many :recipes, through: :recipe_ingredients

  validates :name, presence: true, uniqueness: true, length: { maximum: 80 }
  validates :slug, presence: true, uniqueness: true

  def to_param
    slug
  end
end
