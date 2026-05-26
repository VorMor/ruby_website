class AdminUser < ApplicationRecord
  has_secure_password

  ROLES = {
    "manager" => "Редактор",
    "admin" => "Администратор"
  }.freeze

  normalizes :email, with: ->(email) { email.to_s.strip.downcase }

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :full_name, presence: true, length: { maximum: 100 }
  validates :role, inclusion: { in: ROLES.keys }

  def self.ensure_default_admin!
    email = ENV.fetch("ADMIN_EMAIL", "admin@example.ru")
    password = ENV["ADMIN_PASSWORD"].presence || default_development_password

    find_or_initialize_by(email: email).tap do |admin|
      admin.password = password
      admin.password_confirmation = password
      admin.full_name = "Администратор проекта"
      admin.role = "admin"
      admin.active = true
      admin.save!
    end
  end

  def self.default_development_password
    raise "ADMIN_PASSWORD is required in production" if Rails.env.production?

    "password123"
  end

  def admin?
    role == "admin"
  end
end
