require 'test_helper'

class ItemsControllerTest < ActionController::TestCase

  setup do
    @item = cards(:sting)
  end

  test 'show should redirect to login if not logged in' do
    get :show, params: { id: @item }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'create should redirect to login if not logged in' do
    get :create, params: { item: {name: ''} }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect edit when not logged in' do
    post :edit, params: { id: @item }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect update when not logged in' do
    patch :update, params: { id: @item, name: {name: 'gun'} }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'Item.count' do
      delete :destroy, params: { id: @item }
    end
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'index should redirect index when not logged in' do
    get :index
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'new should redirect index when not logged in' do
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
    get :show, params: { id: @item }
    assert_response :success
  end

  test 'should get new' do
    log_in_as(users(:michael))
    get :new
    assert_response :success
  end

  test 'create should add new item' do
    log_in_as(users(:michael))
    category = categories(:armor)
    rarity = rarities(:uncommon)
    assert_difference 'Item.count', +1 do
      session[:return_to] = 'http://test.host/items'
      post :create, params: { item: {name: 'Nerd', category_id: category.id, rarity_id: rarity.id, attunement: true, description: 'the nerdster'} }
    end

    new_item = Item.find_by_name('Nerd')
    assert new_item
    assert_equal category, new_item.category
    assert_equal rarity, new_item.rarity

    assert_redirected_to items_url
  end

  test 'should get edit' do
    log_in_as(users(:michael))
    post :edit, params: { id: @item }
    assert_response :success
  end

  test 'update should change existing item' do
    log_in_as(users(:michael))
    item = cards(:glamdring)

    assert_no_difference 'Item.count' do
      session[:return_to] = 'http://test.host/items'
      patch :update, params: { id: item.id, item: {name: 'Qua?'} }
    end

    updated_item = Item.find(item.id)
    assert updated_item
    assert_equal 'Qua?', updated_item.name

    assert_redirected_to items_url
  end

  test 'delete should remove item' do
    log_in_as(users(:michael))
    item = cards(:sting)
    assert_difference 'Item.count', -1 do
      @request.env['HTTP_REFERER'] = items_path
      delete :destroy, params: { id: item }
    end
    assert_redirected_to items_url
  end

  test 'should get duplicate' do
    log_in_as(users(:archer))
    item = cards(:glamdring)
    assert_difference 'Item.count', +1 do
      @request.env['HTTP_REFERER'] = items_path
      post :duplicate, params: { id: item.id }
    end
    assert_redirected_to items_url

    duplicate = Item.find_by_name "#{item.name} (copy)"
    assert duplicate
    assert_equal users(:archer), duplicate.user
    assert_equal users(:michael), item.user
  end

end
