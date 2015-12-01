class RecipeCategory < ActiveRecord::Base
  belongs_to :category
  belongs_to :recipe

  validates_presence_of :recipe_id, :category_id
  ## TODO do i need a uniqueness validation here?
end
