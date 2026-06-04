class AddUserIdToRecipes < ActiveRecord::Migration[8.0]
  def change
    unless column_exists?(:recipes, :user_id)
      add_reference :recipes, :user, foreign_key: true, null: true
    end
  end
end