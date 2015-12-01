require 'test_helper'

class RecipesControllerTest < ActionController::TestCase

  test "can create recipe when logged in" do
    @request.headers["auth-token"] = users(:one).auth_token

    assert_difference "Recipe.count" do
      post :create, { name: "Test New Recipe", categories: ["Drinks"] }
    end

    assert_response :created

    assert_not_nil assigns(@recipe)
  end

  test "cannot create recipe when not logged in" do
    assert_no_difference "Recipe.count" do
      post :create, { name: "Test New Recipe" }
    end

    assert_response :unauthorized
  end

  test "cannot create recipe with no name" do
    @request.headers["auth-token"] = users(:one).auth_token

    assert_no_difference "Recipe.count" do
      post :create, { categories: ["Drinks"] }
    end

    assert_response :unprocessable_entity
  end

  test "can get recipe when logged in" do
    @request.headers["auth-token"] = users(:one).auth_token

    get :index, { id: recipes(:one).id }

    assert_response :ok

    assert_not_nil assigns(@recipe)
  end

  test "cannot get recipe when not logged in" do
    get :index, { id: recipes(:one).id }

    assert_response :unauthorized
  end

  test "cannot find recipe not in database" do
      @request.headers["auth-token"] = users(:one).auth_token

      get :show, { id: 1 }

      assert_response :not_found
  end

  test "can update recipe when logged in" do
    @request.headers["auth-token"] = users(:one).auth_token

    patch :update, { id: recipes(:one).id, name: "NEW NAME", categories: ["Drinks"] }

    assert_response :ok
  end

  test "cannot update recipe with blank data" do
    @request.headers["auth-token"] = users(:one).auth_token

    patch :update, { id: recipes(:one).id }

    assert_response :unprocessable_entity
  end

  test "cannot update recipe not owned by user" do
    @request.headers["auth-token"] = users(:two).auth_token

    patch :update, { id: users(:one).recipes.first.id, name: "NEW NAME"}

    assert_response :not_found
  end

  test "can destroy recipe when logged in" do
    @request.headers["auth-token"] = users(:one).auth_token

    assert_difference "Recipe.count",-1 do
      delete :destroy, { id: users(:one).recipes.first.id }
    end

    assert_response :ok
  end

  test "cannot destroy recipe when not logged in" do
    assert_no_difference "Recipe.count" do
      delete :destroy, { id: users(:one).recipes.first.id }
    end

    assert_response :unauthorized
  end

  test "cannot destroy recipe not owned by user" do
    @request.headers["auth-token"] = users(:one).auth_token

    assert_no_difference "Recipe.count" do
      delete :destroy, { id: users(:two).recipes.first.id }
    end

    assert_response :not_found
  end

  test "cannot destroy recipe not in db" do
    @request.headers["auth-token"] = users(:one).auth_token

    assert_no_difference "Recipe.count" do
      delete :destroy, { id: 1 }
    end

    assert_response :not_found
  end
end