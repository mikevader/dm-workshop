require 'test_helper'

module Admin
  class AdminControllerTest < ActionDispatch::IntegrationTest

    setup do
      @user = users(:michael)
    end

    test "should get home" do
      log_in_as @user
      get admin_admin_path
      assert_response :success
    end
  end
end
