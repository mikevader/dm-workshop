require 'test_helper'

class SpellsControllerTest < ActionController::TestCase

  setup do
    @spell = spells(:bane)
  end

  test 'show should' do
    get :show, id: @spell
    assert_response :success
  end

  test 'should redirect create when not logged in' do
    assert_no_difference 'Spell.count' do
      post :create, spell: {description: "Woopsie"}
    end
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'edit should redirect when not logged in' do
    post :edit, id: @spell
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'update should redirect when not logged in' do
    patch :update, id: @spell
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'Spell.count' do
      post :destroy, id: @spell
    end
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'index should' do
    get :index
    assert_response :success
  end

  test 'new should redirect when not logged in' do
    get :new
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should get index' do
    log_in_as(users(:michael))
    get :index
    assert_response :success
  end

  test 'should get show' do
    log_in_as(users(:michael))
    get :show, id: @spell
    assert_response :success
  end

  test 'should get new' do
    log_in_as(users(:michael))
    get :new
    assert_response :success
  end

  test 'should get create' do
    log_in_as(users(:michael))
    assert_difference 'Spell.count', +1 do
      post :create, spell: {name: 'AAA', level: 2, school: 'transmutation'}
    end

    new_spell = Spell.find_by_name('AAA')
    assert new_spell
    assert_equal 2, new_spell.level

    assert_redirected_to spells_url
  end

  test 'should get edit' do
    log_in_as(users(:michael))
    post :edit, id: @spell
    assert_response :success
  end

  test 'should get update' do
    log_in_as(users(:michael))
    assert_no_difference 'Spell.count' do
      patch :update, id: @spell.id, spell: {name: 'ABCD'}
    end

    updated_spell = Spell.find(@spell.id)
    assert updated_spell
    assert_equal 'ABCD', updated_spell.name

    assert_redirected_to spells_url
  end

  test 'should redirect to index after destroy' do
    log_in_as(users(:michael))
    spell = spells(:fireball)
    assert_difference 'Spell.count', -1 do
      delete :destroy, id: spell
    end
    assert_redirected_to spells_url
  end

  test 'should redirect destroy for wrong spell' do
    log_in_as(users(:archer))
    spell = spells(:bane)
    assert_no_difference 'Spell.count' do
      delete :destroy, id: spell
    end
    assert_redirected_to root_url
  end

  test 'should get duplicate' do
    log_in_as(users(:michael))
    spell = spells(:fireball)
    assert_difference 'Spell.count', +1 do
      post :duplicate, id: spell.id
    end
    assert_redirected_to spells_url

    duplicate = Spell.find_by_name "#{spell.name} (copy)"
    assert duplicate
    assert_equal users(:michael), duplicate.user
    assert_equal users(:archer), spell.user
  end
end
