require 'test_helper'

class RecipeCategoryTest < ActiveSupport::TestCase
  test "can create new recipe category" do
    recipe_category = recipes(:one).recipe_categories.new(category_id: categories(:two).id)

    assert recipe_category.save

    assert recipe_category.errors.blank?
  end

  test "can create duplicate recipes categories for different recipes" do
    recipe_category = recipes(:one).recipe_categories.new(category_id: categories(:two).id)
    recipe_category_dupe = recipes(:two).recipe_categories.new(category_id: categories(:two).id)

    assert recipe_category.save
    assert recipe_category_dupe.save

    assert recipe_category.errors.blank?
    assert recipe_category_dupe.errors.blank?
  end

  test "cannot create duplicate recipe categories for same recipe" do
    recipe_category = recipes(:one).recipe_categories.new(category_id: categories(:two).id)
    recipe_category_dupe = recipes(:one).recipe_categories.new(category_id: categories(:two).id)

    assert recipe_category.save
    refute recipe_category_dupe.save

    assert recipe_category.errors.blank?
    assert recipe_category_dupe.errors.present?
  end

  test "cannot create recipe category without a recipe" do
    skip "issues with model validations"

    recipe_category = RecipeCategory.new(category_id: categories(:two).id)

    refute recipe_category.save

    assert recipe_category.errors.present?
  end

  test "cannot create recipe category without a category" do
    skip "issues with model validations"

    recipe_category = RecipeCategory.new(recipe_id: recipes(:one).id)

    refute recipe_category.save

    assert recipe_category.errors.present?
  end

end
