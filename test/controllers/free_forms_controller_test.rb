require 'test_helper'

class FreeFormsControllerTest < ActionController::TestCase
  include CommonCardControllerTest

  setup do
    @card = cards(:cunning_action)
  end

  test 'show should redirect when not logged in' do
    get :show, params: { id: @card }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'create should redirect when not logged in' do
    post :create, params: { card: {name: ''} }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect index when not logged in' do
    get :index
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should get create' do
    log_in_as(users(:michael))
    assert_difference 'Card.count', +1 do
      source = sources(:dnd)
      session[:return_to] = 'http://test.host/free_forms'
      post :create,
           params: {
               free_form: {
                   name: 'Frenzy',
                   source_id: source.id,
                   card_size: '25x50',
                   icon: 'white-book',
                   color: 'black',
                   contents: ''
               }
           }
    end

    new_card = Card.find_by_name('Frenzy')
    assert new_card
    assert_equal 'white-book', new_card.icon

    assert_redirected_to free_forms_url
  end

  test 'should get update' do
    log_in_as(users(:michael))
    card = cards(:action_surge)

    assert_no_difference 'Card.count' do
      session[:return_to] = 'http://test.host/free_forms'
      patch :update, params: { id: card.id, free_form: {name: 'Qua?'} }
    end

    updated_card = Card.find(card.id)
    assert updated_card
    assert_equal 'Qua?', updated_card.name

    assert_redirected_to free_forms_url
  end

  test 'should get destroy' do
    log_in_as(users(:michael))
    card = cards(:cunning_action)
    assert_difference 'Card.count', -1 do
      @request.env['HTTP_REFERER'] = free_forms_path
      delete :destroy, params: { id: card }
    end
    assert_redirected_to free_forms_url
  end

  test 'should get duplicate' do
    log_in_as(users(:archer))
    card = cards(:cunning_action)
    assert_difference 'Card.count', +1 do
      @request.env['HTTP_REFERER'] = free_forms_path
      post :duplicate, params: { id: card.id }
    end
    assert_redirected_to free_forms_url

    duplicate = Card.find_by_name "#{card.name} (copy)"
    assert duplicate
    assert_equal users(:archer), duplicate.user
    assert_equal users(:michael), card.user
  end

end
