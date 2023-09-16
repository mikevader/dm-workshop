require 'test_helper'

class FreeFormsControllerTest < ActionDispatch::IntegrationTest
  include CommonCardControllerTest

  setup do
    @card = cards(:cunning_action)
  end

  test 'show should redirect when not logged in' do
    get free_form_path(@card)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'create should redirect when not logged in' do
    post free_forms_path, params: { card: {name: ''} }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect index when not logged in' do
    get free_forms_path
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should get create' do
    log_in_as(users(:michael))
    assert_difference 'Card.count', +1 do
      source = sources(:dnd)
      get new_free_form_path, headers: { "HTTP_REFERER" => free_forms_url }
      post free_forms_path,
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
      get edit_free_form_path(card), headers: { "HTTP_REFERER" => free_forms_url }
      patch free_form_path(card), params: { id: card.id, free_form: {name: 'Qua?'} }
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
      delete free_form_path(card), headers: { "HTTP_REFERER" => free_forms_url }
    end
    assert_redirected_to free_forms_url
  end

  test 'should get duplicate' do
    log_in_as(users(:archer))
    card = cards(:cunning_action)
    assert_difference 'Card.count', +1 do
      post duplicate_free_form_path(card), headers: { "HTTP_REFERER" => free_forms_url }
    end
    assert_redirected_to free_forms_url

    duplicate = Card.find_by_name "#{card.name} (copy)"
    assert duplicate
    assert_equal users(:archer), duplicate.user
    assert_equal users(:michael), card.user
  end

end
