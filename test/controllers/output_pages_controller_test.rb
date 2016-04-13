require 'test_helper'

class OutputPagesControllerTest < ActionController::TestCase

  test 'all should redirect to login if not logged in' do
    get :all, search: 'name = halo'
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'monster should redirect to login if not logged in' do
    get :monsters, search: 'name = halo'
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'free_form should redirect to login if not logged in' do
    get :free_forms, search: 'name = halo'
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'item should redirect to login if not logged in' do
    get :items, search: 'name = halo'
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'spell should redirect to login if not logged in' do
    get :spells, search: 'name = halo'
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should output cards for all' do
    log_in_as(users(:michael))
    get :all, search: 'name = halo'
    assert_response :success
  end

  test 'should output cards for monsters' do
    log_in_as(users(:michael))
    get :monsters, search: 'name = halo'
    assert_response :success
  end

  test 'should output cards for free forms' do
    log_in_as(users(:michael))
    get :free_forms, search: 'name = halo'
    assert_response :success
  end

  test 'should output cards for items' do
    log_in_as(users(:michael))
    get :items, search: 'name = halo'
    assert_response :success
  end

  test 'should output cards for spells' do
    log_in_as(users(:michael))
    get :spells, search: 'name = halo'
    assert_response :success
  end
end
