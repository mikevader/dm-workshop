require 'test_helper'

class ItemsInterfaceTest < ActionDispatch::IntegrationTest

  setup do
    @user = users(:michael)
    @category = categories(:weapon)
    @rarity = rarities(:rare)
    @source = sources(:dnd)
  end

  test "items interface should handle invalid input" do
    log_in_as(@user)
    get items_path
    #assert_select 'div.pagination'
    # Invalid submission
    assert_no_difference 'Item.count' do
      post items_path, params: { item: { name: "", category_id: nil, rarity_id: nil, attunement: false, description: ''} }
    end
    assert_select 'div#error_explanation'
  end

  test 'items interface should handle valid input' do
    log_in_as(@user)
    get items_path
    # Valid submission
    name = "heroblade"
    assert_difference 'Item.count', 1 do
      get new_item_path, headers: { referer: items_url }
      post items_path,
           params: {
               item: {
                   name: name,
                   source_id: @source.id,
                   card_size: '25x50',
                   category_id: @category.id,
                   rarity_id: @rarity.id,
                   attunement: false,
                   description: 'some stuff'} }
    end
    assert_redirected_to items_url
    follow_redirect!
    assert_match name, response.body
    assert_select 'td', text: name
  end

  test 'items interface should handle delete' do
    log_in_as(@user)
    get items_path
    # Delete a post.
    assert_select 'a[aria-label=?]', 'delete'
    first_item = Item.first
    assert_difference 'Item.count', -1 do
      delete item_path(first_item)
    end
  end
end
