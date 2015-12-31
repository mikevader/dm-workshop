require 'test_helper'

class ItemsControllerTest < ActionController::TestCase
  
  def setup
    @item = items(:sting)
  end

  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to login_url
  end

  test "should redirect edit when not logged in" do
    post :edit, id: @item
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch :update, id: @item, name: { name: 'gun' }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Item.count' do
      delete :destroy, id: @item
    end
    assert_redirected_to login_url
  end

  test "should get show" do
    get :show, id: @item
    assert_response :success
  end
  
  test "delete should remove item" do
    log_in_as(users(:michael))
    item = items(:sting)
    assert_difference 'Item.count', -1 do
      delete :destroy, id: item
    end
    assert_redirected_to items_url
  end

  test "create should add new item" do
    log_in_as(users(:michael))
    category = categories(:armor)
    rarity = rarities(:uncommon)
    assert_difference 'Item.count', +1 do
      post :create, item: { name: 'Nerd', category_id: category.id, rarity_id: rarity.id, attunement: true, description: 'the nerdster' }
    end
    assert_redirected_to items_url
  end
  
  test "update should change existing item" do
    log_in_as(users(:michael))
    item = items(:glamdring)

    assert_no_difference 'Item.count' do
      patch :update, id: item.id, item: { name: 'Qua?' }
    end
    assert_redirected_to items_url
  end
end
