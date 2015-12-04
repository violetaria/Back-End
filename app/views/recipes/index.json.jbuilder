json.success "true"
json.recipes do json.array! @categories.each do |category|
  json.category category
  json.recipes @categorized_recipes[category.to_sym] do |recipe|
    json.name recipe.name
    json.id recipe.id
    json.directions recipe.steps
    json.ingredients recipe.ingredient_amounts
  end
end
  end
