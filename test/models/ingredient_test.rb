require 'test_helper'

class IngredientTest < ActiveSupport::TestCase
  test "can create new ingredient" do
    ingredient = Ingredient.new(name: "turkey jerky")

    assert ingredient.save

    assert ingredient.errors.blank?
  end

  test "cannot create two ingredients with same name" do
    ingredient = Ingredient.new(name: ingredients(:one).name)

    refute ingredient.save

    assert ingredient.errors.present?
  end

end
