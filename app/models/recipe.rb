class Recipe < ActiveRecord::Base
  belongs_to :user
  has_many :recipe_categories
  has_many :categories, through: :recipe_categories

  validates_presence_of :name, :user_id
  validates_uniqueness_of :name, scope: [:user_id]


  def category_names
    self.categories.map { |category| category[:name] }
  end

  def category_names=(new_categories)
    categories = new_categories.map { |category| Category.find_by!(name: category) }
    self.categories = categories
  end
end

