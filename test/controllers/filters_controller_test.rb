require 'test_helper'

class FiltersControllerTest < ActionController::TestCase

  setup do
    @filter = filters(:one)
  end

  test 'show should redirect when not logged in' do
    get :show, id: @filter
    assert_redirected_to login_url
  end

  test 'create should redirect when not logged in' do
    post :create, filter: { name: '', query: '' }
    assert_redirected_to login_url
  end

  test 'edit should redirect when not logged in' do
    post :edit, id: @filter
    assert_redirected_to login_url
  end

  test 'update should redirect when not logged in' do
    patch :update, id: @filter
    assert_redirected_to login_url
  end

  test 'destroy should redirect when not logged in' do
    delete :destroy, id: @filter
    assert_redirected_to login_url
  end

  test 'get should redirect index when not logged in' do
    [:index, :new].each do |action|
      get action
      assert_redirected_to login_url
    end
  end

  test 'post should redirect index when not logged in' do
    [:create].each do |action|
      post action
      assert_redirected_to login_url
    end
  end

  test 'should get index' do
    log_in_as(users(:michael))
    get :index
    assert_response :success
  end

  test 'should get show' do
    log_in_as(users(:michael))
    get :show, id: @filter
    assert_response :success
  end

  test 'should get new' do
    log_in_as(users(:michael))
    get :new
    assert_response :success
  end

  test 'should get create' do
    log_in_as(users(:michael))
    assert_difference 'Filter.count', +1 do
      post :create, filter: { name: 'AAA', query: 'name ~ end' }
    end

    new_filter = Filter.find_by_name('AAA')

    assert_redirected_to filter_path(new_filter)
  end

  test 'should get edit' do
    log_in_as(users(:michael))
    post :edit, id: @filter
    assert_response :success
  end

  test 'should get update' do
    log_in_as(users(:michael))
    patch :update, id: @filter.id, filter: { name: @filter.name, query: @filter.query }
    assert_response :success
  end

  test 'should get destory' do
    log_in_as(users(:michael))
    assert_difference 'Filter.count', -1 do
      delete :destroy, id: @filter
    end
    assert_redirected_to filters_url
  end

end
