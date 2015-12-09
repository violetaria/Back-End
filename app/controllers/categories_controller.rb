class CategoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @categories = Category.all
    render "index.json.jbuilder", status: :ok
  end

  def show
    categories = Category.find_by!(id: params[:id])
    @recipes = categories.recipes.includes(:recipe_ingredients,:categories, :directions)
                         .references(:recipe_categories)
                         .where("recipe_categories.category_id = ?",params[:id])
    render "show.json.jbuilder", status: :ok
  end

end
