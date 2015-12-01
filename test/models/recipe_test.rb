require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "can create recipe" do
    recipe = users(:one).recipes.new(name: "Test Recipe")

    assert recipe.save
    assert recipe.errors.blank?
  end


  test "cannot create recipe without user" do
    recipe = Recipe.new(name: "Test Recipe")

    refute recipe.save
    assert recipe.errors.present?
  end

  test "cannot create recipe without name" do
    recipe = users(:one).recipes.new()

    refute recipe.save
    assert recipe.errors.present?
  end

  test "one user cannot create recipes with same name" do
    recipe = users(:one).recipes.new(name: users(:one).recipes.first.name)

    refute recipe.save
    assert recipe.errors.present?
  end

  test "two users can create recipe with same name" do
    recipe = users(:two).recipes.new(name: users(:one).recipes.first.name)
    assert recipe.save
    assert recipe.errors.blank?
  end

end
