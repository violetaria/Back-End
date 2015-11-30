require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "can create new category" do
    category = Category.new(name: "Test")

    assert category.save
    assert category.errors.blank?
  end

  test "cannot create category without name" do
    category = Category.new()

    refute category.save
    assert category.errors.present?
  end

  test "cannot create two categories with same name" do
    category = Category.new(name: categories(:one).name)

    refute category.save
    assert category.errors.present?
  end
end
