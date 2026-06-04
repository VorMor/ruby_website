class Recipe < ApplicationRecord
  include Sluggable

  DIFFICULTIES = {
    "easy" => "Легко",
    "medium" => "Средне",
    "hard" => "Сложно"
  }.freeze

  slug_from :title

  belongs_to :category
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients

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

  def to_param
    slug
  end
end
