class RecipesController < ApplicationController
  before_action :authenticate_user!

  def show
    @recipe = current_user.recipes.includes(:directions).includes(:categories).find_by!(id: params[:id])

    render "show.json.jbuilder", status: :ok
  end

  def index
    @recipes = current_user.recipes.includes(:directions).includes(:categories)

    render "index.json.jbuilder", status: :ok
  end

  def create
    @recipe = current_user.recipes.new(recipe_params)
    if @recipe.save
      @recipe.steps = step_params
      @recipe.ingredient_amounts = ingredient_params
      render "create.json.jbuilder", status: :created
    else
      render json: { errors: @recipe.errors.full_messages }, status: :unprocessable_entity
    end
    ## TODO add additional creates here once other models are created
  end

  def update
    recipe = current_user.recipes.find_by!(id: params[:id])

    recipe.update(recipe_params)

    if recipe.errors.blank?
      render json: { success: "true" }, status: :ok
    else
      render json: { errors: recipe.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    recipe = current_user.recipes.find_by!(id: params[:id])

    recipe.destroy

    render json: { success: "true" }, status: :ok
  end

  private
  def recipe_params
    params.permit(:name, :category_names => [])
  end

  def step_params
    params.permit(:steps => []).require(:steps)
  end

  def ingredient_params
    params.permit({ingredients: [:name,:unit,:amount]}).require(:ingredients)
  end
end