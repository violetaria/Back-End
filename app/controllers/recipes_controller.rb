class RecipesController < ApplicationController
  before_action :authenticate_user!

  def show
    @recipe = current_user.recipes.find_by!(id: params[:id])

    render "show.json.jbuilder", status: :ok
  end

  def index
    @recipes = current_user.recipes

    render "index.json.jbuilder", status: :ok
  end

  def create
    #@recipe = current_user.recipes.new(recipe_params)
    @recipe = current_user.recipes.new(name: params[:name],
                                       category_names: params[:categories])
    if @recipe.save
      render "create.json.jbuilder", status: :created
    else
      render json: { errors: @recipe.errors.full_messages }, status: :unprocessable_entity
    end

    ## TODO add additional creates here once other models are created
  end

  def update
    recipe = current_user.recipes.find_by!(id: params[:id])

    #recipe.update(recipe_params)
    recipe.update(name: params[:name],
                  category_names: params[:categories])

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
    params.permit(:name, :category_names => [:name] )
  end
end