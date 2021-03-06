class Category < ActiveRecord::Base
  has_many :recipe_categories, dependent: :destroy
  has_many :recipes, through: :recipe_categories

  validates_presence_of :name
  validates_uniqueness_of :name
end
