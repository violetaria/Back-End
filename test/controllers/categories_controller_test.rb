require 'test_helper'

class CategoriesControllerTest < ActionController::TestCase

  test "can list all categories when logged in" do
    @request.headers["auth-token"] = users(:one).auth_token

    get :index

    assert_response :ok

    assert_not_nil assigns(@categories)
  end

  test "cannot list all categories when not logged in" do
    get :index

    assert_response :unauthorized
  end

end