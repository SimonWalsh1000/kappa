require 'test_helper'

class SurvivalsControllerTest < ActionController::TestCase
  setup do
    @survival = survivals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:survivals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create survival" do
    assert_difference('Survival.count') do
      post :create, survival: { b: @survival.b, ci_lower: @survival.ci_lower, ci_upper: @survival.ci_upper, hr: @survival.hr, name: @survival.name, p: @survival.p, se: @survival.se, user_id: @survival.user_id }
    end

    assert_redirected_to survival_path(assigns(:survival))
  end

  test "should show survival" do
    get :show, id: @survival
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @survival
    assert_response :success
  end

  test "should update survival" do
    patch :update, id: @survival, survival: { b: @survival.b, ci_lower: @survival.ci_lower, ci_upper: @survival.ci_upper, hr: @survival.hr, name: @survival.name, p: @survival.p, se: @survival.se, user_id: @survival.user_id }
    assert_redirected_to survival_path(assigns(:survival))
  end

  test "should destroy survival" do
    assert_difference('Survival.count', -1) do
      delete :destroy, id: @survival
    end

    assert_redirected_to survivals_path
  end
end
