class CreateSearchLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :search_logs do |t|
      t.string :query
      t.references :category, null: true, foreign_key: true
      t.text :ingredient_names
      t.integer :results_count, null: false, default: 0
      t.string :ip_address
      t.string :user_agent

      t.timestamps
    end

    add_index :search_logs, :query
    add_index :search_logs, :created_at
  end
end
