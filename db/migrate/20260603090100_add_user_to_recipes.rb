class AddUserToRecipes < ActiveRecord::Migration[8.1]
  def change
    add_reference :recipes, :user, foreign_key: true, null: true
  end
end
