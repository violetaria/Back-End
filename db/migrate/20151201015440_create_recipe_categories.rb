class CreateRecipeCategories < ActiveRecord::Migration
  def change
    create_table :recipe_categories do |t|
      t.integer :recipe_id, null: false
      t.integer :category_id, null: false

      t.timestamps null: false
    end
  end
end
