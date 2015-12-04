class AddUrlAndSourceInfoToRecipe < ActiveRecord::Migration
  def change
    add_column :recipes, :source_name, :string, null: true
    add_column :recipes, :source_url, :string, null: true
    add_column :recipes, :source_image_url, :string, null: true
  end
end
