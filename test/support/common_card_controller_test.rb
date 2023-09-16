module CommonCardControllerTest
  extend ActiveSupport::Concern
  included do

    test 'should redirect new when not logged in' do
      get new_polymorphic_path(@card)
      assert_not flash.empty?
      assert_redirected_to login_url
    end

    test 'edit should redirect when not logged in' do
      get edit_polymorphic_path(@card)
      assert_not flash.empty?
      assert_redirected_to login_url
    end

    test 'update should redirect when not logged in' do
      patch polymorphic_path(@card), params: { id: @card }
      assert_not flash.empty?
      assert_redirected_to login_url
    end

    test 'should redirect destroy when not logged in' do
      assert_no_difference 'Card.count' do
        delete polymorphic_path(@card)
      end
      assert_not flash.empty?
      assert_redirected_to login_url
    end

    test 'should get index' do
      log_in_as(users(:michael))
      get polymorphic_path(@card)
      assert_response :success
    end

    test 'should get show' do
      log_in_as(users(:michael))
      get polymorphic_path(@card)
      assert_response :success
    end

    test 'should get new' do
      log_in_as(users(:michael))
      get new_polymorphic_path(@card)
      assert_response :success
    end

    test 'should get edit' do
      log_in_as(users(:michael))
      get edit_polymorphic_path(@card)
      assert_response :success
    end

  end
end
