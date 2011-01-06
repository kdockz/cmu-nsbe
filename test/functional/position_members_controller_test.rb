require 'test_helper'

class PositionMembersControllerTest < ActionController::TestCase
  setup do
    @position_member = position_members(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:position_members)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create position_member" do
    assert_difference('PositionMember.count') do
      post :create, :position_member => @position_member.attributes
    end

    assert_redirected_to position_member_path(assigns(:position_member))
  end

  test "should show position_member" do
    get :show, :id => @position_member.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @position_member.to_param
    assert_response :success
  end

  test "should update position_member" do
    put :update, :id => @position_member.to_param, :position_member => @position_member.attributes
    assert_redirected_to position_member_path(assigns(:position_member))
  end

  test "should destroy position_member" do
    assert_difference('PositionMember.count', -1) do
      delete :destroy, :id => @position_member.to_param
    end

    assert_redirected_to position_members_path
  end
end
