require 'test_helper'

class FiltersControllerTest < ActionController::TestCase

  setup do
    @filter = filters(:one)
  end

  test 'show should redirect when not logged in' do
    get :show, params: { id: @filter }
    assert_redirected_to login_url
  end

  test 'create should redirect when not logged in' do
    post :create, params: { filter: { name: '', query: '' } }
    assert_redirected_to login_url
  end

  test 'edit should redirect when not logged in' do
    post :edit, params: { id: @filter }
    assert_redirected_to login_url
  end

  test 'update should redirect when not logged in' do
    patch :update, params: { id: @filter }
    assert_redirected_to login_url
  end

  test 'destroy should redirect when not logged in' do
    delete :destroy, params: { id: @filter }
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
    skip
    log_in_as(users(:michael))
    get :show, params: { id: @filter }
    assert_response :success
  end

  test 'should get new' do
    log_in_as(users(:michael))
    get :new
    assert_response :success
  end

  test 'should get create' do
    log_in_as(users(:michael))
    query = 'name ~ end'
    assert_difference 'Filter.count', +1 do
      post :create, params: { filter: { name: 'AAA', query: query} }
    end

    new_filter = Filter.find_by_name('AAA')
    assert new_filter
    assert_equal query, new_filter.query

    assert_redirected_to filter_path(new_filter)
  end

  test 'should get edit' do
    log_in_as(users(:michael))
    post :edit, params: { id: @filter }
    assert_response :success
  end

  test 'should get update' do
    log_in_as(users(:michael))
    filter_name = 'aaaa'
    filter_query = 'labels in (jdf, jdg)'
    id = @filter.id
    assert_no_difference 'Filter.count' do
      patch :update, params: { id: id, filter: { name: filter_name, query: filter_query } }
    end

    filter = Filter.find(id)
    assert filter
    assert_equal filter_name, filter.name
    assert_equal filter_query, filter.query

    assert_redirected_to filter_path(@filter)
  end

  test 'should get destory' do
    log_in_as(users(:michael))
    assert_difference 'Filter.count', -1 do
      delete :destroy, params: { id: @filter }
    end
    assert_redirected_to filters_url
  end
end
