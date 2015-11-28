require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
  end

  test "should get import" do
    get :import
    assert_response :success
  end

end
