class Direction < ActiveRecord::Base
  belongs_to :recipe

  validates_presence_of :recipe_id, :step
  validates_uniqueness_of :step, scope: [:recipe_id]

end
