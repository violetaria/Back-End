require 'test_helper'

class RecipesControllerTest < ActionController::TestCase

  test "can create recipe when logged in" do
    @request.headers["auth-token"] = users(:one).auth_token

    assert_difference ["Recipe.count","RecipeCategory.count","Ingredient.count","RecipeIngredient.count","Direction.count"] do
      post :create, { name: "Test New Recipe",
                      category_names: [categories(:one).name],
                      steps: ["step 1"],
                      ingredients:[{name: "NEW INGREDIENT", amount: 2.5, unit: "cups"}]}

    end

    assert_response :created

    assert_not_nil assigns(:recipe)
  end

  test "cannot create recipe when not logged in" do
    assert_no_difference ["Recipe.count","RecipeCategory.count","Ingredient.count","RecipeIngredient.count","Direction.count"] do
      post :create, {  name: "Test New Recipe",
                       category_names: [categories(:one).name],
                       steps: ["step 1"],
                       ingredients:[{name: "NEW INGREDIENT", amount: 2.5, unit: "cups"}]}
    end

    assert_response :unauthorized

    assert_nil assigns(:recipe)
  end

  test "cannot create recipe with no name" do
    @request.headers["auth-token"] = users(:one).auth_token

    assert_no_difference ["Recipe.count","RecipeCategory.count","Ingredient.count","RecipeIngredient.count","Direction.count"] do
      post :create, { category_names: [categories(:one).name],
                      steps: ["step 1"],
                      ingredients:[{name: "NEW INGREDIENT", amount: 2.5, unit: "cups"}]}
    end

    assert_response :unprocessable_entity

    assert_nil assigns(:recipe).id
  end

  test "can get all recipes when logged in" do
    @request.headers["auth-token"] = users(:one).auth_token

    get :index

    assert_response :ok

    assert_not_nil assigns(:categorized_recipes)
    assert_not_nil assigns(:categories)
  end

  test "cannot get all recipes when not logged in" do
    get :index

    assert_response :unauthorized

    assert_nil assigns(:categorized_recipes)
    assert_nil assigns(:categories)
  end

  test "cannot get recipe not in database" do
    @request.headers["auth-token"] = users(:one).auth_token

    get :show, { id: 1 }

    assert_response :not_found

    assert_nil assigns(:recipe)
  end

  test "can update recipe when logged in" do
    @request.headers["auth-token"] = users(:one).auth_token

    patch :update, { id: recipes(:one).id, name: "NEW NAME", categories: ["Drinks"] }

    assert_response :ok
  end

  test "cannot update recipe with blank name" do
    @request.headers["auth-token"] = users(:one).auth_token

    patch :update, { id: recipes(:one).id, name: nil }

    assert_response :unprocessable_entity
  end

  test "cannot update recipe not owned by user" do
    @request.headers["auth-token"] = users(:two).auth_token

    patch :update, { id: users(:one).recipes.first.id, name: "NEW NAME"}

    assert_response :not_found
  end

  test "can destroy recipe when logged in" do
    @request.headers["auth-token"] = users(:one).auth_token

    assert_difference ["Recipe.count","RecipeCategory.count","Direction.count","RecipeIngredient.count"],-1 do
      delete :destroy, { id: users(:one).recipes.first.id }
    end

    assert_response :ok
  end

  test "cannot destroy recipe when not logged in" do
    assert_no_difference ["Recipe.count","RecipeCategory.count","Direction.count","RecipeIngredient.count"] do
      delete :destroy, { id: users(:one).recipes.first.id }
    end

    assert_response :unauthorized
  end

  test "cannot destroy recipe not owned by user" do
    @request.headers["auth-token"] = users(:one).auth_token

    assert_no_difference ["Recipe.count","RecipeCategory.count","Direction.count","RecipeIngredient.count"] do
      delete :destroy, { id: users(:two).recipes.first.id }
    end

    assert_response :not_found
  end

  test "cannot destroy recipe not in db" do
    @request.headers["auth-token"] = users(:one).auth_token

    assert_no_difference ["Recipe.count","RecipeCategory.count","Direction.count","RecipeIngredient.count"] do
      delete :destroy, { id: 1 }
    end

    assert_response :not_found
  end

  test "can search api while logged in" do
    @request.headers["auth-token"] = users(:one).auth_token

    get :search_api, { query: "burgers" }

    assert_response :ok

    assert_not_nil (:recipes)
  end

  test "cannot search api when not logged in" do
    get :search_api, { query: "burgers" }

    assert_response :unauthorized


    assert_nil assigns(:recipes)
  end

  test "can retrieve from api when logged in" do
    @request.headers["auth-token"] = users(:one).auth_token

    get :search_api, { query: "burgers" }

    get :retrieve_api, { id: assigns(:recipes).first[:id] }

    assert_response :ok

    assert_not_nil assigns(:recipe_info)
    assert_not_nil assigns(:steps)
    assert_not_nil assigns(:ingredients)
  end

  test "cannot retrieve from api when not logged in" do
    @request.headers["auth-token"] = users(:one).auth_token
    get :search_api, { query: "burgers" }
    @request.headers["auth-token"] = nil
    get :retrieve_api, { id: assigns(:recipes).first[:id] }

    assert_response :unauthorized

    assert_nil assigns(:recipe_info)
    assert_nil assigns(:steps)
    assert_nil assigns(:ingredients)
  end

  test "can import recipe from api when logged in" do
    @request.headers["auth-token"] = users(:one).auth_token
    get :search_api, { query: "burgers" }

    assert_difference ["Recipe.count","RecipeCategory.count"] do
      post :import_api, { id: assigns(:recipes).first[:id], category_names: [categories(:one).name] }
    end

    assert_response :created

    assert_not_nil assigns(:recipe)
  end
end