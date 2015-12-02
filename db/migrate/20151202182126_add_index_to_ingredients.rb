class AddIndexToIngredients < ActiveRecord::Migration
  def change
    add_index :ingredients, :name
  end
end
