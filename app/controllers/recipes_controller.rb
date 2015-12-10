class RecipesController < ApplicationController
  before_action :authenticate_user!

  def show
    @recipe = current_user.recipes.includes(:categories).find_by!(id: params[:id])

    render "show.json.jbuilder", status: :ok
  end

  def index
    categorize_flag = params["categorized"].nil? ? true : to_bool!(params["categorized"])
    if categorize_flag
      @categorized_recipes = Hash.new
      @categories = Category.all
      @categories.each do |category|
        @categorized_recipes[category.name.to_sym] = []
        category.name
      end

      current_user.recipes.includes(:recipe_ingredients,:categories, :directions).order("directions.id").map do |recipe|
        recipe.categories.each do |category|
          @categorized_recipes[category.name.to_sym].push(recipe)
        end
      end

      render "index_categorized.json.jbuilder", status: :ok
    else
      @recipes = current_user.recipes.includes(:categories,:recipe_ingredients,:directions).order("directions.id")
      render "index.json.jbuilder", status: :ok
    end
  end

  def search_api
    api = Spoonacular.new
    results = api.search_recipes(params[:query])
    if results["totalResults"] > 0
      @recipes = SpoonacularFormatter.get_recipes(results)
      render "search_api.json.jbuilder", status: :ok
    else
      render json: { errors: "No results found which match query \'#{params[:query]}\'" }, status: :not_found
    end
  end

  def retrieve_api
    api = Spoonacular.new
    data = api.get_recipe_info(params[:id])
    if data["status"] == "failure"
      render json: { errors: "Recipe ID: #{params[:id]} not found in Spoonacular DB" }, status: :not_found
    else
      @recipe_info = SpoonacularFormatter.get_recipe_info(data,api.base_images_uri)
      recipe_data = api.get_recipe_data(@recipe_info[:source_url])
      @steps = SpoonacularFormatter.get_recipe_steps(recipe_data)
      @ingredients = SpoonacularFormatter.get_recipe_ingredients(recipe_data)
      render "retrieve_api.json.jbuilder", status: :ok
    end
  end

  def import_api
    api = Spoonacular.new
    data = api.get_recipe_info(params[:id])
    if data["status"] == "failure"
      render json: { errors: "Recipe ID: #{params[:id]} not found in Spoonacular DB" }, status: :not_found
    else
      recipe_info = SpoonacularFormatter.get_recipe_info(data,api.base_images_uri)
      recipe_data = api.get_recipe_data(recipe_info[:source_url])
      steps = SpoonacularFormatter.get_recipe_steps(recipe_data)
      ingredients = SpoonacularFormatter.get_recipe_ingredients(recipe_data)
      @recipe = current_user.recipes.new(name: recipe_info[:name],
                                         source_name: recipe_info[:source_name],
                                         source_url: recipe_info[:source_url],
                                         source_image_url: recipe_info[:source_image_url])
      if @recipe.save
        @recipe.category_names = params["category_names"]
        @recipe.steps = steps
        @recipe.ingredient_amounts = ingredients
        render "import.json.jbuilder", status: :created
      else
        render json: { errors: @recipe.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def create
    @recipe = current_user.recipes.new(recipe_params)
    if @recipe.save
      @recipe.steps = step_params
      @recipe.category_names = category_params
      @recipe.ingredient_amounts = ingredient_params
      render "create.json.jbuilder", status: :created
    else
      render json: { errors: @recipe.errors.full_messages }, status: :unprocessable_entity
    end
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
    if recipe.errors.blank?
      render json: { success: "true" }, status: :ok
    else
      render json: { errors: recipe.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def process_image
    ocr = OCRFormatter.new
    @results = ocr.import_recipe(params[:my_image].tempfile.path)
    render "process_image.json.jbuilder", status: :ok
  end

  private
  def recipe_params
    params.permit(:name, :my_image)
  end

  def category_params
    params.permit(:category_names => []).require(:category_names)
  end

  def step_params
    params.permit(:steps => []).require(:steps)
  end

  def ingredient_params
    params.permit({ingredients: [:name,:unit,:amount]}).require(:ingredients)
  end

  def to_bool!(value)
    ActiveRecord::ConnectionAdapters::Column::TRUE_VALUES.include?(value)
  end
end