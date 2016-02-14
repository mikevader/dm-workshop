require 'test_helper'

class CardsControllerTest < ActionController::TestCase

  setup do
    @card = cards(:cunning_action)
  end

  test 'show should redirect when not logged in' do
    get :show, id: @card
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'create should redirect when not logged in' do
    post :create, card: {name: ''}
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'edit should redirect when not logged in' do
    post :edit, id: @card
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'update should redirect when not logged in' do
    patch :update, id: @card
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'destroy should redirect when not logged in' do
    delete :destroy, id: @card
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect index when not logged in' do
    get :index
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect new when not logged in' do
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
    get :show, id: @card
    assert_response :success
  end

  test 'should get new' do
    log_in_as(users(:michael))
    get :new
    assert_response :success
  end

  test 'should get create' do
    log_in_as(users(:michael))
    assert_difference 'Card.count', +1 do
      post :create, card: {name: 'Frenzy', icon: 'white-book', color: 'black', contents: ''}
    end

    new_card = Card.find_by_name('Frenzy')
    assert new_card
    assert_equal 'white-book', new_card.icon

    assert_redirected_to cards_url
  end

  test 'should get edit' do
    log_in_as(users(:michael))
    post :edit, id: @card
    assert_response :success
  end

  test 'should get update' do
    log_in_as(users(:michael))
    card = cards(:action_surge)

    assert_no_difference 'Card.count' do
      patch :update, id: card.id, card: {name: 'Qua?'}
    end

    updated_card = Card.find(card.id)
    assert updated_card
    assert_equal 'Qua?', updated_card.name

    assert_redirected_to cards_url
  end

  test 'should get destroy' do
    log_in_as(users(:michael))
    card = cards(:cunning_action)
    assert_difference 'Card.count', -1 do
      delete :destroy, id: card
    end
    assert_redirected_to cards_url
  end

  test 'should get duplicate' do
    log_in_as(users(:archer))
    card = cards(:cunning_action)
    assert_difference 'Card.count', +1 do
      post :duplicate, id: card.id
    end
    assert_redirected_to cards_url

    duplicate = Card.find_by_name "#{card.name} (copy)"
    assert duplicate
    assert_equal users(:archer), duplicate.user
    assert_equal users(:michael), card.user
  end

end
