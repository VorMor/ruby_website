class Recipe < ApplicationRecord
  include Sluggable

  DIFFICULTIES = {
    "easy" => "Легко",
    "medium" => "Средне",
    "hard" => "Сложно"
  }.freeze

  attr_writer :ingredients_text

  slug_from :title

  belongs_to :category
  belongs_to :user, optional: true
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
  has_many :favorite_recipes, dependent: :destroy
  has_many :favorited_by_users, through: :favorite_recipes, source: :user

  accepts_nested_attributes_for :recipe_ingredients, allow_destroy: true

  validates :title, presence: true, uniqueness: true, length: { maximum: 120 }
  validates :slug, presence: true, uniqueness: true
  validates :description, :instructions, presence: true
  validates :difficulty, inclusion: { in: DIFFICULTIES.keys }
  validates :cooking_time, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 600 }
  validates :servings, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 40 }
  validates :views_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :published, -> { where(published: true) }
  scope :recent, -> { order(created_at: :desc) }
  scope :popular, -> { order(views_count: :desc, title: :asc) }
  scope :by_category, ->(category_id) { where(category_id: category_id) if category_id.present? }
  scope :max_time, ->(minutes) { where(cooking_time: ..minutes.to_i) if minutes.present? }

  def self.search(query)
    return all if query.blank?

    patterns = search_patterns(query)
    left_joins(:ingredients)
      .where(
        patterns.map { "recipes.title LIKE ? OR recipes.description LIKE ? OR ingredients.name LIKE ?" }.join(" OR "),
        *patterns.flat_map { |pattern| [ pattern, pattern, pattern ] }
      )
      .distinct
  end

  def self.search_patterns(query)
    raw_query = sanitize_sql_like(query.to_s.strip)

    # SQLite не умеет полноценно приводить кириллицу к нижнему регистру,
    # поэтому ищем несколько естественных вариантов написания запроса.
    [
      raw_query,
      raw_query.downcase,
      raw_query.upcase,
      raw_query.capitalize
    ].uniq.map { |variant| "%#{variant}%" }
  end

  def self.with_ingredients(raw_names)
    names = raw_names.to_s.split(",").map { |name| name.strip.downcase }.compact_blank
    return all if names.empty?

    joins(:ingredients)
      .where(names.map { "LOWER(ingredients.name) LIKE ?" }.join(" OR "), *names.map { |name| "%#{sanitize_sql_like(name)}%" })
      .distinct
  end

  def difficulty_name
    DIFFICULTIES.fetch(difficulty)
  end

  def ingredients_text
    @ingredients_text ||= recipe_ingredients.includes(:ingredient).map do |item|
      amount = item.amount&.to_f&.then { |value| value == value.to_i ? value.to_i : value }
      [ item.ingredient.name, amount, item.unit.presence, item.note.presence ].compact_blank.join(" | ")
    end.join("\n")
  end

  def apply_ingredients_text!(raw_text)
    @ingredients_text = raw_text
    parsed_rows = RecipeIngredientParser.new(raw_text).rows

    transaction do
      recipe_ingredients.destroy_all

      parsed_rows.each do |row|
        ingredient = Ingredient.find_or_create_by!(name: row[:name])
        recipe_ingredients.create!(
          ingredient: ingredient,
          amount: row[:amount],
          unit: row[:unit],
          note: row[:note]
        )
      end
    end
  end

  def owned_by?(candidate_user)
    user_id.present? && user_id == candidate_user&.id
  end

  def favorited_by?(candidate_user)
    return false unless candidate_user

    favorite_recipes.exists?(user_id: candidate_user.id)
  end

  def to_param
    slug
  end
end
