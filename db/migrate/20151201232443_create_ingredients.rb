class CreateIngredients < ActiveRecord::Migration
  def change
    create_table :ingredients do |t|
      t.integer :recipe_id,  null: false
      t.string :name, null: false
      t.float :amount
      t.string :unit, null: false

      t.timestamps null: false
    end
  end
end
