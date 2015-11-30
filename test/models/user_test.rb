require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "can_create_user" do
    user = User.new(email: "test@user.com",
                    password: "password")

    assert user.save
    assert user.errors.empty?
  end

  test "cannot_create_user_without_email" do
    user = User.new(email: "test@user.com")

    refute user.save
    assert user.errors.present?
  end

  test "cannot_create_user_without_password" do
    user = User.new(password: "password")

    refute user.save
    assert user.errors.present?
  end

  test "cannot_create_user_with_invalid_email" do
    user = User.new(email: "test@",
                    password: "password")

    refute user.save
    assert user.errors.present?
  end

  test "cannot_create_two_users_with_same_email" do
    user = User.new(email: "test@user.com",
                    password: "password")

    assert user.save
    assert user.errors.empty?

    user = User.new(email: "test@user.com",
                    password: "password")

    refute user.save
    assert user.errors.present?
  end
end
