require 'test_helper'

class CliniciansControllerTest < ActionController::TestCase
  setup do
    @clinician = clinicians(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:clinicians)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create clinician" do
    assert_difference('Clinician.count') do
      post :create, clinician: { country: @clinician.country, email: @clinician.email, general: @clinician.general, name: @clinician.name, society: @clinician.society, specialty: @clinician.specialty }
    end

    assert_redirected_to clinician_path(assigns(:clinician))
  end

  test "should show clinician" do
    get :show, id: @clinician
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @clinician
    assert_response :success
  end

  test "should update clinician" do
    patch :update, id: @clinician, clinician: { country: @clinician.country, email: @clinician.email, general: @clinician.general, name: @clinician.name, society: @clinician.society, specialty: @clinician.specialty }
    assert_redirected_to clinician_path(assigns(:clinician))
  end

  test "should destroy clinician" do
    assert_difference('Clinician.count', -1) do
      delete :destroy, id: @clinician
    end

    assert_redirected_to clinicians_path
  end
end
