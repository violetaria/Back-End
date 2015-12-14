class Recipe < ActiveRecord::Base
  include PgSearch
  multisearchable :against => [:name]

  pg_search_scope :search_by_name,
                  :against => :name,
                  :using => { :tsearch => {:any_word => true }}

  pg_search_scope :search_any_ingredient, :associated_against => {
                  :ingredients => :name },
                  :using => {
                  :tsearch => {:any_word => true }}


  pg_search_scope :search_all_ingredients,
                  :associated_against => { :ingredients => :name }

  belongs_to :user

  has_many :recipe_categories, dependent: :destroy
  has_many :categories, through: :recipe_categories
  has_many :directions, dependent: :destroy
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients

  has_attached_file :my_image, styles: { medium: "300x300>", thumb: "100x100>" } , default_url: ""

  validates_attachment_content_type :my_image, content_type: /\Aimage\/.*\Z/
  validates_with AttachmentSizeValidator, attributes: :my_image, less_than: 1.megabytes
  validates_presence_of :name, :user_id
  validates_uniqueness_of :name, scope: [:user_id]

  def category_names
    self.categories.map { |cat| { name: cat[:name], id: cat[:id] } }
  end

  def category_names=(new_categories)
   categories = new_categories.each.map { |cat| Category.find_by!(name: cat) }
   self.categories = categories
  end

  def steps
    self.directions.map { |step| step[:step] }
  end

  def steps=(new_steps)
    steps = new_steps.select { |step| step.length > 0 }.map{ |step| self.directions.create(step: step) }
    self.directions = steps
  end

  def ingredient_amounts
    self.ingredients.includes(:recipe_ingredients).select("ingredients.name,recipe_ingredients.unit,recipe_ingredients.amount").map do |item|
      Hash[:name,item[:name],:amount,item[:amount],:unit,item[:unit]]
    end

  end

  def ingredient_amounts=(new_amounts)
    new_amounts.each do | item |
      ingredient = Ingredient.find_or_create_by!(name: item[:name])
      new_ingredient = self.recipe_ingredients.find_or_initialize_by(ingredient_id: ingredient.id,
                               unit: item[:unit], amount: item[:amount])

      new_ingredient.amount = new_ingredient.new_record? ? item[:amount] : new_ingredient.amount + item[:amount]
      new_ingredient.save!
    end
    self.recipe_ingredients
  end
end

