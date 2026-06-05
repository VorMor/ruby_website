# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_06_03_090200) do
  create_table "admin_users", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "full_name", null: false
    t.string "password_digest", null: false
    t.string "role", default: "manager", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["role"], name: "index_admin_users_on_role"
  end

  create_table "categories", force: :cascade do |t|
    t.string "color", default: "#2f855a", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "favorite_recipes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "recipe_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["recipe_id"], name: "index_favorite_recipes_on_recipe_id"
    t.index ["user_id", "recipe_id"], name: "index_favorite_recipes_on_user_id_and_recipe_id", unique: true
    t.index ["user_id"], name: "index_favorite_recipes_on_user_id"
  end

  create_table "ingredients", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_ingredients_on_name", unique: true
    t.index ["slug"], name: "index_ingredients_on_slug", unique: true
  end

  create_table "recipe_ingredients", force: :cascade do |t|
    t.decimal "amount", precision: 8, scale: 2
    t.datetime "created_at", null: false
    t.integer "ingredient_id", null: false
    t.string "note"
    t.integer "recipe_id", null: false
    t.string "unit", default: "", null: false
    t.datetime "updated_at", null: false
    t.index ["ingredient_id"], name: "index_recipe_ingredients_on_ingredient_id"
    t.index ["recipe_id", "ingredient_id"], name: "index_recipe_ingredients_on_recipe_id_and_ingredient_id", unique: true
    t.index ["recipe_id"], name: "index_recipe_ingredients_on_recipe_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "cooking_time", null: false
    t.datetime "created_at", null: false
    t.text "description", null: false
    t.string "difficulty", default: "medium", null: false
    t.string "image_url"
    t.text "instructions", null: false
    t.boolean "published", default: true, null: false
    t.integer "servings", default: 2, null: false
    t.string "slug", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "views_count", default: 0, null: false
    t.index ["category_id"], name: "index_recipes_on_category_id"
    t.index ["cooking_time"], name: "index_recipes_on_cooking_time"
    t.index ["difficulty"], name: "index_recipes_on_difficulty"
    t.index ["published"], name: "index_recipes_on_published"
    t.index ["slug"], name: "index_recipes_on_slug", unique: true
    t.index ["title"], name: "index_recipes_on_title"
    t.index ["user_id"], name: "index_recipes_on_user_id"
  end

  create_table "search_logs", force: :cascade do |t|
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.text "ingredient_names"
    t.string "ip_address"
    t.string "query"
    t.integer "results_count", default: 0, null: false
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.index ["category_id"], name: "index_search_logs_on_category_id"
    t.index ["created_at"], name: "index_search_logs_on_created_at"
    t.index ["query"], name: "index_search_logs_on_query"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.text "bio"
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "full_name", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_users_on_active"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "favorite_recipes", "recipes"
  add_foreign_key "favorite_recipes", "users"
  add_foreign_key "recipe_ingredients", "ingredients"
  add_foreign_key "recipe_ingredients", "recipes"
  add_foreign_key "recipes", "categories"
  add_foreign_key "recipes", "users"
  add_foreign_key "search_logs", "categories"
end
