json.success "true"
json.recipes do
  json.array! @recipes do |recipe|
    json.id recipe.id
    json.name recipe.name
    json.categories recipe.category_names
  end
end
