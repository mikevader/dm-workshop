require 'test_helper'

class OutputPagesControllerTest < ActionDispatch::IntegrationTest

  test 'all should redirect to login if not logged in' do
    get print_path, params: { search: 'name = halo' }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'monster should redirect to login if not logged in' do
    get print_monsters_path, params: { search: 'name = halo' }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'free_form should redirect to login if not logged in' do
    get print_free_forms_path, params: { search: 'name = halo' }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'item should redirect to login if not logged in' do
    get print_items_path, params: { search: 'name = halo' }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'spell should redirect to login if not logged in' do
    skip('temporary its allowed as anonymous to print spell cards.')
    get print_spells_path, params: { search: 'name = halo' }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should output cards for all' do
    log_in_as(users(:michael))
    get print_path, params: { search: 'name = *' }
    assert_response :success
    assert assigns[:pages]
    assert_equal 2, assigns[:pages].size
    assert_equal 5, assigns[:pages].first.cards.size
    assert_equal 2, assigns[:pages].second.cards.size
  end

  test 'should output cards for monsters' do
    log_in_as(users(:michael))
    get print_monsters_path, params: { search: 'name ~ shadow' }
    assert_response :success

    assert assigns[:pages]
    card_1 = assigns[:pages].first.cards.first
    assert_equal 'Shadow Demon', card_1.name
  end

  test 'should output cards for free forms' do
    log_in_as(users(:michael))
    get print_free_forms_path, params: { search: 'name ~ cunning' }
    assert_response :success

    assert assigns[:pages]
    assert_equal 1, assigns[:pages].size
    card_1 = assigns[:pages].first.cards.first
    assert_equal 'Cunning Action', card_1.name
  end

  test 'should output only free form cards' do
    log_in_as(users(:michael))
    get print_free_forms_path, params: { search: '' }
    assert_response :success

    assert assigns[:pages]
    assert_equal 1, assigns[:pages].size
    assert_equal 2, assigns[:pages].first.cards.size
  end

  test 'should output cards for items' do
    log_in_as(users(:michael))
    get print_items_path, params: { search: '' }
    assert_response :success
    assert assigns[:pages]
    assert_equal 1, assigns[:pages].size
    assert_equal 2, assigns[:pages].first.cards.size
  end

  test 'should output cards for spells' do
    log_in_as(users(:michael))
    get print_spells_path, params: { search: 'level >= 0' }
    assert_response :success
    assert assigns[:pages]
    assert_equal 1, assigns[:pages].size
    assert_equal 2, assigns[:pages].first.cards.size
  end

  test 'should output cards for spells with queries including relations' do
    log_in_as(users(:michael))
    get print_spells_path, params: { search: 'level >= 0 AND classes IN (sorcerer)' }
    assert_response :success
    assert assigns[:pages]
    assert_equal 1, assigns[:pages].size
    assert_equal 1, assigns[:pages].first.cards.size
  end

end
