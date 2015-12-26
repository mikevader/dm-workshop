require 'test_helper'

class CardsControllerTest < ActionController::TestCase
  setup do
    @card = cards(:cunning_action)
  end

  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to login_url
  end

  test "should get index" do
    log_in_as(users(:michael))
    get :index
    assert_response :success
  end

  test "should get show" do
    log_in_as(users(:michael))
    get :show, id: @card
    assert_response :success
  end

  test "should get new" do
    log_in_as(users(:michael))
    get :new
    assert_response :success
  end

  test "should get create" do
    log_in_as(users(:michael))
    assert_difference 'Card.count', +1 do
      post :create, card: { name: 'Frenzy', icon: 'white-book', color: 'black', contents: '' }
    end
    assert_redirected_to cards_url
  end

  test "should get edit" do
    log_in_as(users(:michael))
    post :edit, id: @card
    assert_response :success
  end

  test "should get update" do
    log_in_as(users(:michael))
    card = cards(:action_surge)

    assert_no_difference 'Card.count' do
      patch :update, id: card.id, card: { name: 'Qua?' }
    end
    assert_redirected_to cards_url
  end

  test "should get destroy" do
    log_in_as(users(:michael))
    card = cards(:cunning_action)
    assert_difference 'Card.count', -1 do
      delete :destroy, id: card
    end
    assert_redirected_to cards_url
  end

end
