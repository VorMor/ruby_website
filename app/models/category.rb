class Category < ApplicationRecord
  include Sluggable

  has_many :recipes, dependent: :restrict_with_error
  has_many :search_logs, dependent: :nullify

  validates :name, presence: true, uniqueness: true, length: { maximum: 80 }
  validates :slug, presence: true, uniqueness: true
  validates :color, presence: true, format: { with: /\A#[0-9a-fA-F]{6}\z/ }

  def to_param
    slug
  end
end
