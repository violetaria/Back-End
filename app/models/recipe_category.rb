class RecipeCategory < ActiveRecord::Base
  belongs_to :category
  belongs_to :recipe

  validates_presence_of :recipe_id, :category_id
  validates_uniqueness_of :category_id, scope: [:recipe_id]
end
