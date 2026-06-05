class User < ApplicationRecord
  has_secure_password

  has_many :recipes, dependent: :nullify
  has_many :favorite_recipes, dependent: :destroy
  has_many :favorite_recipe_items, through: :favorite_recipes, source: :recipe

  normalizes :email, with: ->(email) { email.to_s.strip.downcase }

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :full_name, presence: true, length: { maximum: 100 }
  validates :bio, length: { maximum: 1_000 }

  def to_param
    id.to_s
  end
end
