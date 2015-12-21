require 'test_helper'

module Admin
  class AdminControllerTest < ActionController::TestCase

    def setup
      @user = users(:michael)
    end

    test "should get home" do
      log_in_as @user
      get :home
      assert_response :success
    end
  end
end
