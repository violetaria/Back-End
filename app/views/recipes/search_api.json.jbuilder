json.success "true"
json.recipes do json.array! @recipes.each do |recipe|
    json.id recipe[:id]
    json.name recipe[:name]
    json.source_image_url recipe[:source_image_url]
  end
end
