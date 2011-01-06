require 'test_helper'

class AvailablePositionsControllerTest < ActionController::TestCase
  setup do
    @available_position = available_positions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:available_positions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create available_position" do
    assert_difference('AvailablePosition.count') do
      post :create, :available_position => @available_position.attributes
    end

    assert_redirected_to available_position_path(assigns(:available_position))
  end

  test "should show available_position" do
    get :show, :id => @available_position.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @available_position.to_param
    assert_response :success
  end

  test "should update available_position" do
    put :update, :id => @available_position.to_param, :available_position => @available_position.attributes
    assert_redirected_to available_position_path(assigns(:available_position))
  end

  test "should destroy available_position" do
    assert_difference('AvailablePosition.count', -1) do
      delete :destroy, :id => @available_position.to_param
    end

    assert_redirected_to available_positions_path
  end
end
