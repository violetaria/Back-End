#module FlourPower
  class Spoonacular
    include HTTParty
    base_uri "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com"

    attr_reader :base_images_uri
    def initialize()
      @auth = {
          "X-Mashape-Key" => ENV["SPOONACULAR_KEY"]
      }

      @base_images_uri = "https://spoonacular.com/recipeImages/"
    end

    def search_recipes(query)
      response = Spoonacular.get("/recipes/search?query=#{query}",
                     headers: @auth)
      response.parsed_response
    end

    def get_recipe_info(recipe_id)
      response = Spoonacular.get("/recipes/#{recipe_id}/information",
                                 headers: @auth)
      response.parsed_response
    end

    def get_recipe_data(source_url)
      url_encoded = ERB::Util.url_encode(source_url)
      Spoonacular.get("/recipes/extract?forceExtraction=false&url=#{url_encoded}",
                      headers: @auth)
    end
  end
#end
