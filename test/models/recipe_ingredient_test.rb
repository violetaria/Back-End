require 'test_helper'

class RecipeIngredientTest < ActiveSupport::TestCase
  test "can create recipe ingredient" do
    recipe_ingredient = recipes(:two).recipe_ingredients.new(ingredient_id: ingredients(:one).id, amount: 1.0, unit: "cups")

    assert recipe_ingredient.save

    assert recipe_ingredient.errors.blank?
  end

  test "cannot create duplicate records attached to one recipe" do
    recipe_ingredient = recipes(:two).recipe_ingredients.new(ingredient_id: ingredients(:one).id, amount: 1.0, unit: "cups")
    recipe_ingredient_dupe = recipes(:two).recipe_ingredients.new(ingredient_id: ingredients(:one).id, amount: 1.0, unit: "cups")

    assert recipe_ingredient.save
    refute recipe_ingredient_dupe.save

    assert recipe_ingredient.errors.blank?
    assert recipe_ingredient_dupe.errors.present?
  end

  test "can create duplciate record attached to two recipes" do
    recipe_ingredient = recipes(:two).recipe_ingredients.new(ingredient_id: ingredients(:one).id, amount: 1.0, unit: "cups")
    recipe_ingredient_dupe = recipes(:one).recipe_ingredients.new(ingredient_id: ingredients(:three).id, amount: 1.0, unit: "cups")

    assert recipe_ingredient.save
    assert recipe_ingredient_dupe.save

    assert recipe_ingredient.errors.blank?
    assert recipe_ingredient_dupe.errors.blank?
  end
end