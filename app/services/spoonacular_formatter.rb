class SpoonacularFormatter

  def self.get_recipes(data)
    image_base_uri = data["baseUri"]
    data["results"].map do |recipe|
      { id: recipe["id"],
        name: recipe["title"],
        source_image_url: image_base_uri+recipe["image"] }
    end
  end

  def self.get_recipe_info(data,base_uri)
    { source_url: data["sourceUrl"],
      source_name: data["sourceName"],
      source_id: data["id"],
      name: data["title"],
      source_image_url: base_uri+data["image"] }
  end

  def self.get_recipe_steps(data)
    recipe_text = Nokogiri::HTML(data["text"])
    directions_html = recipe_text.xpath("//html/body/ol")
    if directions_html.present?
      directions_html.first.children.map do |step|
        step.text
      end
    else
      data["text"] ||= ""
      data["text"].split("\n").map do |step|
        step.lstrip.rstrip unless step.nil?
      end
    end
  end

  def self.get_recipe_ingredients(data)
    data["extendedIngredients"].map do |ingredient|
      { name: ingredient["name"],
        amount: ingredient["amount"],
        unit: ingredient["unit"] }
    end
  end
end