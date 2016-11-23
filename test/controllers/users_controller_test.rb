require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: { ats: @user.ats, author: @user.author, complete: @user.complete, country: @user.country, cryobiopsy: @user.cryobiopsy, email: @user.email, experience: @user.experience, fellowship: @user.fellowship, finish: @user.finish, finished: @user.finished, first_name: @user.first_name, histopathology: @user.histopathology, imaging: @user.imaging, institution: @user.institution, institution_type: @user.institution_type, ipf_approach: @user.ipf_approach, ipfphys: @user.ipfphys, job_description: @user.job_description, last_name: @user.last_name, mdt_frequency: @user.mdt_frequency, meeting: @user.meeting }
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    patch :update, id: @user, user: { ats: @user.ats, author: @user.author, complete: @user.complete, country: @user.country, cryobiopsy: @user.cryobiopsy, email: @user.email, experience: @user.experience, fellowship: @user.fellowship, finish: @user.finish, finished: @user.finished, first_name: @user.first_name, histopathology: @user.histopathology, imaging: @user.imaging, institution: @user.institution, institution_type: @user.institution_type, ipf_approach: @user.ipf_approach, ipfphys: @user.ipfphys, job_description: @user.job_description, last_name: @user.last_name, mdt_frequency: @user.mdt_frequency, meeting: @user.meeting }
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end
end
