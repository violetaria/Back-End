json.success "true"
json.recipes do json.array! @categories.each do |category|
  json.category category.name
  json.category_id category.id
  json.recipes @categorized_recipes[category.name.to_sym] do |recipe|
    json.name recipe.name
    json.id recipe.id
    json.directions recipe.steps
    json.ingredients recipe.ingredient_amounts
    json.source_name recipe.source_name
    json.source_url recipe.source_url
    json.source_image_url recipe.source_image_url
    json.my_image recipe.my_image
  end
end
end
