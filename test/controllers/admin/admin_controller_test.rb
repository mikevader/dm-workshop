require 'test_helper'

module Admin
  class AdminControllerTest < ActionDispatch::IntegrationTest

    def setup
      @user = users(:michael)
    end

    test "should get home" do
      log_in_as @user
      get admin_admin_path
      assert_response :success
    end
  end
end
