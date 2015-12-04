class ChangeUnitToBeNullable < ActiveRecord::Migration
  def change
    change_column :recipe_ingredients, :unit, :string, :null => true
  end
end
