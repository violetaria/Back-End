class Ingredient < ActiveRecord::Base
  belongs_to :recipe

  validates_presence_of :name, :recipe_id, :unit, :amount
end
