require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "can_create_recipe" do
    recipe = users(:one).recipes.new(name: "Test Recipe")

    assert recipe.save
    assert recipe.errors.blank?
  end


  test "cannot_create_recipe_without_user" do
    recipe = Recipe.new(name: "Test Recipe")

    refute recipe.save
    assert recipe.errors.present?
  end

  test "cannot_create_recipe_without_name" do
    recipe = users(:one).recipes.new()

    refute recipe.save
    assert recipe.errors.present?
  end

  test "one_user_cannot_create_recipe_with_same_name" do
    recipe = users(:one).recipes.new(name: "Test Recipe")

    assert recipe.save
    assert recipe.errors.blank?

    recipe = users(:one).recipes.new(name: "Test Recipe")
    refute recipe.save
    assert recipe.errors.present?
  end

  test "two_users_can_create_recipe_with_same_name" do
    recipe = users(:one).recipes.new(name: "Test Recipe")

    assert recipe.save
    assert recipe.errors.blank?

    recipe = users(:two).recipes.new(name: "Test Recipe")
    assert recipe.save
    assert recipe.errors.blank?
  end

end
