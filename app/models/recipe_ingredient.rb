class RecipeIngredient < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :ingredient

  validates_presence_of :amount
  validates_uniqueness_of :amount, :unit, scope: [:recipe_id, :ingredient_id]
end
