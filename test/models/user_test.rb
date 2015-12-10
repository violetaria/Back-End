require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "can create user" do
    user = User.new(email: "test@user.com",
                    password: "password")

    assert user.save
    assert user.errors.empty?
  end

  test "cannot create user without password" do
    user = User.new(email: "test@user.com")

    refute user.save
    assert user.errors.present?
  end

  test "cannot create user without email" do
    user = User.new(password: "password")

    refute user.save
    assert user.errors.present?
  end

  test "cannot create user with invalid email" do
    user = User.new(email: "test@",
                    password: "password")

    refute user.save
    assert user.errors.present?
  end

  test "cannot create two users with same email" do
    user = User.new(email: users(:one).email,
                    password: "password")

    refute user.save
    assert user.errors.present?
  end
end
