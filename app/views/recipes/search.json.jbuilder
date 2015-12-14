json.success "true"
json.count @results.count
json.recipes do json.array! @results.each do |recipe|
  json.name recipe.name
  json.id recipe.id
  json.categories recipe.category_names
  json.directions recipe.steps
  json.ingredients recipe.ingredient_amounts
  json.source_name recipe.source_name
  json.source_url recipe.source_url
  json.source_image_url recipe.source_image_url
  json.my_image recipe.my_image
end
end
