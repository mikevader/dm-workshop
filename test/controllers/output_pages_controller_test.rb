require 'test_helper'

class OutputPagesControllerTest < ActionController::TestCase

  test 'all should redirect to login if not logged in' do
    get :all, params: { search: 'name = halo' }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'monster should redirect to login if not logged in' do
    get :monsters, params: { search: 'name = halo' }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'free_form should redirect to login if not logged in' do
    get :free_forms, params: { search: 'name = halo' }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'item should redirect to login if not logged in' do
    get :items, params: { search: 'name = halo' }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'spell should redirect to login if not logged in' do
    get :spells, params: { search: 'name = halo' }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should output cards for all' do
    log_in_as(users(:michael))
    get :all, params: { search: 'name = *' }
    assert_response :success
    assert assigns[:cards]
    assert_equal 7, assigns[:cards].size
  end

  test 'should output cards for monsters' do
    log_in_as(users(:michael))
    get :monsters, params: { search: 'name ~ shadow' }
    assert_response :success

    assert assigns[:cards]
    card_1 = assigns[:cards].first
    assert_equal 'Shadow Demon', card_1.name
  end

  test 'should output cards for free forms' do
    log_in_as(users(:michael))
    get :free_forms, params: { search: 'name ~ cunning' }
    assert_response :success

    assert assigns[:cards]
    assert_equal 1, assigns[:cards].size
    card_1 = assigns[:cards].first
    assert_equal 'Cunning Action', card_1.name
  end

  test 'should output only free form cards' do
    log_in_as(users(:michael))
    get :free_forms, params: { search: '' }
    assert_response :success

    assert assigns[:cards]
    assert_equal 2, assigns[:cards].size
  end

  test 'should output cards for items' do
    log_in_as(users(:michael))
    get :items, params: { search: '' }
    assert_response :success
    assert assigns[:cards]
    assert_equal 2, assigns[:cards].size
  end

  test 'should output cards for spells' do
    log_in_as(users(:michael))
    get :spells, params: { search: 'level >= 0' }
    assert_response :success
    assert assigns[:cards]
    assert_equal 2, assigns[:cards].size
  end
end
