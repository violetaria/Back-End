require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  test "can register user" do
    assert_difference "User.count" do
      post :new, { email: "test@email.com", password: "password" }
    end

    assert_response :created

    assert_not_nil assigns(:user)
  end

  test "cannot register user without email" do
    assert_no_difference "User.count" do
      post :new, { password: "password" }
    end

    assert_response :unprocessable_entity
  end

  test "cannot register user without password" do
    assert_no_difference "User.count" do
      post :new, { email: "test@email.com" }
    end

    assert_response :unprocessable_entity
  end

  test "can login registered user" do
    post :create, { email: users(:one).email, password: "password" }

    assert_response :accepted

    assert_not_nil assigns(:user)

    assert_equal assigns(@user)[:user][:auth_token], users(:one).auth_token
  end

  test "cannot login un-registered user" do
    post :create, { email: users(:one).email, password: "TEST" }

    assert_response :unauthorized
  end



end