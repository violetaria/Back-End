class CreateDirections < ActiveRecord::Migration
  def change
    create_table :directions do |t|
      t.integer :recipe_id, null: false
      t.string :step, null: false

      t.timestamps null: false
    end
  end
end
