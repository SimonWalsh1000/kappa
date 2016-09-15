require 'test_helper'

class ScoresControllerTest < ActionController::TestCase
  setup do
    @score = scores(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:scores)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create score" do
    assert_difference('Score.count') do
      post :create, score: { case_id: @score.case_id, ctd: @score.ctd, description: @score.description, dx1: @score.dx1, dx2: @score.dx2, dx3: @score.dx3, dx5: @score.dx5, dxcon2: @score.dxcon2, dxcon4: @score.dxcon4, experience: @score.experience, fellowship: @score.fellowship, histopathology: @score.histopathology, imaging: @score.imaging, ipf_number_cases: @score.ipf_number_cases, job: @score.job, mdt_frequency: @score.mdt_frequency, meeting_type: @score.meeting_type, nsip: @score.nsip, user_id: @score.user_id }
    end

    assert_redirected_to score_path(assigns(:score))
  end

  test "should show score" do
    get :show, id: @score
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @score
    assert_response :success
  end

  test "should update score" do
    patch :update, id: @score, score: { case_id: @score.case_id, ctd: @score.ctd, description: @score.description, dx1: @score.dx1, dx2: @score.dx2, dx3: @score.dx3, dx5: @score.dx5, dxcon2: @score.dxcon2, dxcon4: @score.dxcon4, experience: @score.experience, fellowship: @score.fellowship, histopathology: @score.histopathology, imaging: @score.imaging, ipf_number_cases: @score.ipf_number_cases, job: @score.job, mdt_frequency: @score.mdt_frequency, meeting_type: @score.meeting_type, nsip: @score.nsip, user_id: @score.user_id }
    assert_redirected_to score_path(assigns(:score))
  end

  test "should destroy score" do
    assert_difference('Score.count', -1) do
      delete :destroy, id: @score
    end

    assert_redirected_to scores_path
  end
end
