require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "can_create_new_category" do
    category = Category.new(name: "Test")

    assert category.save
    assert category.errors.blank?
  end

  test "cannot_create_category_without_name" do
    category = Category.new()

    refute category.save
    assert category.errors.present?
  end

  test "cannot_create_two_categories_with_same_name" do
    category = Category.new(name: "Test")
    assert category.save
    assert category.errors.blank?

    category = Category.new(name: "Test")
    refute category.save
    assert category.errors.present?
  end
end
