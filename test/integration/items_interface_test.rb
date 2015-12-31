require 'test_helper'

class ItemsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @category = categories(:weapon)
    @rarity = rarities(:rare)
  end

  test "items interface" do
    log_in_as(@user)
    get items_path
    #assert_select 'div.pagination'
    # Invalid submission
    assert_no_difference 'Item.count' do
      post items_path, item: { name: "", category_id: nil, rarity_id: nil, attunement: false, description: ""}
    end
    assert_select 'div#error_explanation'
    # Valid submission
    name = "heroblade"
    assert_difference 'Item.count', 1 do
      post items_path, item: { name: name, category_id: @category.id, rarity_id: @rarity.id, attunement: false, description: "some stuff"}
    end
    assert_redirected_to items_url
    follow_redirect!
    assert_match name, response.body
    # Delete a post.
    assert_select 'a[aria-label=?]', 'delete'
    first_item = Item.paginate(page: 1).first
    assert_difference 'Item.count', -1 do
      delete item_path(first_item)
    end
  end
end
