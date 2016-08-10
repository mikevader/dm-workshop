require 'test_helper'

class MonstersControllerTest < ActionController::TestCase

  setup do
    @monster = cards(:shadow_demon)
  end

  test 'show should redirect when not logged in' do
    get :show, params: { id: @monster }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'create should redirect when not logged in' do
    assert_no_difference 'Monster.count' do
      post :create, params: { monster: {name: ''} }
    end
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'edit should redirect when not logged in' do
    post :edit, params: { id: @monster }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'update should redirect when not logged in' do
    patch :update, params: { id: @monster }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'destroy should redirect when not logged in' do
    assert_no_difference 'Monster.count' do
      delete :destroy, params: { id: @monster }
    end
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'get should redirect index when not logged in' do
    [:index, :new].each do |action|
      get action
      assert_not flash.empty?
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
    get :show, params: { id: @monster }
    assert_response :success
  end

  test 'should get new' do
    log_in_as(users(:michael))
    get :new
    assert_response :success
  end

  test 'should get create' do
    log_in_as(users(:michael))
    assert_difference 'Monster.count', +1 do
      session[:return_to] = 'http://test.host/monsters'
      post :create, params: { monster: {name: 'AAA', bonus: 2, monster_size: 'huge', monster_type: 'humanoid', armor_class: '19 (plate)', hit_points: 150, strength: 8, dexterity: 8, constitution: 8, intelligence: 12, wisdom: 12, charisma: 12} }
    end

    new_monster = Monster.find_by_name('AAA')
    assert new_monster
    assert_equal 2, new_monster.bonus

    assert_redirected_to monsters_url
  end

  test 'should get edit' do
    log_in_as(users(:michael))
    post :edit, params: { id: @monster }
    assert_response :success
  end

  test 'should get update' do
    log_in_as(users(:michael))
    assert_no_difference 'Monster.count' do
      session[:return_to] = 'http://test.host/monsters'
      patch :update, params: { id: @monster.id, monster: {name: 'ABCD'} }
    end

    updated_monster = Monster.find(@monster.id)
    assert updated_monster
    assert_equal 'ABCD', updated_monster.name

    assert_redirected_to monsters_url
  end

  test 'should get destory' do
    log_in_as(users(:michael))
    assert_difference 'Monster.count', -1 do
      @request.env['HTTP_REFERER'] = monsters_path
      delete :destroy, params: { id: @monster }
    end
    assert_redirected_to monsters_url
  end

  test 'should get duplicate' do
    log_in_as(users(:archer))
    monster = cards(:shadow_demon)
    assert_difference 'Monster.count', +1 do
      @request.env['HTTP_REFERER'] = monsters_path
      post :duplicate, params: { id: monster.id }
    end
    assert_redirected_to monsters_url

    duplicate = Monster.find_by_name "#{monster.name} (copy)"
    assert duplicate
    assert_equal users(:archer), duplicate.user
    assert_equal users(:michael), monster.user
  end
end
