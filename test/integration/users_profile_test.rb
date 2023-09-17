require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  setup do
    @user = users(:michael)
  end

  test 'index should not be visible for anonymous in users' do
    get users_path
    assert_redirected_to login_url
  end

  test 'profile should not be visible for anonymous in users' do
    get user_path(@user)
    assert_redirected_to login_url
  end

  test 'profile display' do
    log_in_as(@user)
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    assert_match /(Filters .*#{@user.filters.count}.*)/, response.body
    assert_match /(Cards .*#{@user.cards.count}.*)/, response.body
    assert_match /(Items .*#{@user.items.count}.*)/, response.body
    assert_match /(Monsters .*#{@user.monsters.count}.*)/, response.body
    assert_match /(Spells .*#{@user.spells.count}.*)/, response.body
  end
end
