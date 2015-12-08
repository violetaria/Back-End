require 'test_helper'

class DirectionTest < ActiveSupport::TestCase
  test "can create new direction" do
    direction = recipes(:one).directions.new(step: "Test Step")

    assert direction.save

    assert direction.errors.blank?
  end

  test "cannot create same direction twice in a recipe" do
    direction = recipes(:one).directions.new(step: "Test Step")
    direction_dupe = recipes(:one).directions.new(step: "Test Step")

    assert direction.save
    refute direction_dupe.save

    assert direction.errors.blank?
    assert direction_dupe.errors.present?
  end

  test "cannot create direction without recipe" do
    direction = Direction.new(step: "Test Step")

    refute direction.save

    assert direction.errors.present?
  end
end
