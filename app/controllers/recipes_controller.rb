class RecipesController < ApplicationController
  before_action :authenticate_user!

  def show
    @recipe = current_user.recipes.includes(:directions).includes(:categories).find_by!(id: params[:id])

    render "show.json.jbuilder", status: :ok
  end

  def index
    @categorized_recipes = Hash.new
    @categories = Category.all.map do |category|
      @categorized_recipes[category.name.to_sym] = []
      category.name
    end

    current_user.recipes.map do |recipe|
      recipe.categories.each do |category|
        @categorized_recipes[category.name.to_sym].push(recipe)
      end
    end
    render "index.json.jbuilder", status: :ok
  end

  def import
    api = Spoonacular.new
    recipe_info = api.get_recipe_info(params["id"])
    recipe_data = api.get_recipe_data(recipe_info[:source_url])
    recipe_text = Nokogiri::HTML(recipe_data["text"])
    directions_html = recipe_text.xpath("//html/body/ol")
    if directions_html.present?
      steps = directions_html.first.children.map do |step|
        step.text
      end
    else
      steps = recipe_data["text"].split("\n").map do |step|
        step.lstrip.rstrip
      end
    end

    ingredients = recipe_data["extendedIngredients"].map do |ingredient|
      {name: ingredient["name"],amount: ingredient["amount"],unit: ingredient["unit"]}
    end

    @recipe = current_user.recipes.new(name: recipe_info[:name],
                                       category_names: params["category_names"])

    if @recipe.save
      @recipe.steps = steps
      @recipe.ingredient_amounts = ingredients
      render "import.json.jbuilder", status: :created
    else
      render json: { errors: @recipe.errors.full_messages }, status: :unprocessable_entity
    end
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