require 'test_helper'

class ItemsControllerTest < ActionDispatch::IntegrationTest
  include CommonCardControllerTest

  setup do
    @card = @item = cards(:sting)
  end

  test 'show should redirect to login if not logged in' do
    get item_path(@item)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'create should redirect to login if not logged in' do
    post items_path, params: { item: {name: ''} }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'index should redirect index when not logged in' do
    get items_path
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'create should add new item' do
    log_in_as(users(:michael))
    category = categories(:armor)
    rarity = rarities(:uncommon)
    source = sources(:dnd)
    assert_difference 'Item.count', +1 do
      get new_item_path, headers: { "HTTP_REFERER" => items_url }
      post items_path,
           params: {
               item: {
                   name: 'Nerd',
                   source_id: source.id,
                   card_size: '25x50',
                   category_id: category.id,
                   rarity_id: rarity.id,
                   attunement: true,
                   description: 'the nerdster'} }
    end

    new_item = Item.find_by_name('Nerd')
    assert new_item
    assert_equal category, new_item.category
    assert_equal rarity, new_item.rarity

    assert_redirected_to items_url
  end

  test 'update should change existing item' do
    log_in_as(users(:michael))
    item = cards(:glamdring)

    assert_no_difference 'Item.count' do
      get edit_item_path(item), headers: { "HTTP_REFERER" => items_url }
      patch item_path(item), params: { id: item.id, item: {name: 'Qua?'} }
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
      delete item_path(item), headers: { "HTTP_REFERER" => items_url }
    end
    assert_redirected_to items_url
  end

  test 'should get duplicate' do
    log_in_as(users(:archer))
    item = cards(:glamdring)
    assert_difference 'Item.count', +1 do
      post duplicate_item_path(item), headers: { "HTTP_REFERER" => items_url }
    end
    assert_redirected_to items_url

    duplicate = Item.find_by_name "#{item.name} (copy)"
    assert duplicate
    assert_equal users(:archer), duplicate.user
    assert_equal users(:michael), item.user
  end

end
