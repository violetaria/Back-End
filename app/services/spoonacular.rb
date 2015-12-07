#module FlourPower
  class Spoonacular
    include HTTParty
    base_uri "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com"
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
      data = response.parsed_response
      if data["status"] == "failure"
        nil
      else
        { source_url: data["sourceUrl"],
          source_name: data["sourceName"],
          source_id: data["id"],
          name: data["title"],
          source_image_url: @base_images_uri+data["image"]}
      end
    end

    def get_recipe_data(source_url)
      url_encoded = ERB::Util.url_encode(source_url)
      Spoonacular.get("/recipes/extract?forceExtraction=false&url=#{url_encoded}",
                      headers: @auth)
    end
  end
#end
