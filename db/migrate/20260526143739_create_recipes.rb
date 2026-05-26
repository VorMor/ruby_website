class CreateRecipes < ActiveRecord::Migration[8.1]
  def change
    create_table :recipes do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :description, null: false
      t.text :instructions, null: false
      t.integer :cooking_time, null: false
      t.integer :servings, null: false, default: 2
      t.string :difficulty, null: false, default: "medium"
      t.string :image_url
      t.boolean :published, null: false, default: true
      t.integer :views_count, null: false, default: 0
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end

    add_index :recipes, :slug, unique: true
    add_index :recipes, :title
    add_index :recipes, :difficulty
    add_index :recipes, :cooking_time
    add_index :recipes, :published
  end
end
