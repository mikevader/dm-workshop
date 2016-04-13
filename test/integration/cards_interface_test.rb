require 'test_helper'

class CardsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "cards interface should handle invalid input" do
    log_in_as(@user)
    get cards_path
    #assert_select 'div.pagination'
    # Invalid submission
    assert_no_difference 'Card.count' do
      post cards_path, card: { name: "" }
    end
    assert_select 'div#error_explanation'
  end

  test 'cards interface should handle valid input' do
    log_in_as(@user)
    get cards_path
    # Valid submission
    name = "heroblade"
    session[:return_to] = cards_url
    assert_difference 'Card.count', 1 do
      get new_card_path, nil, referer: cards_url
      post cards_path, card: { name: name, icon: 'white-book', color: 'indigo', contents: 'subtitle | Rogue feature' }
    end

    assert_redirected_to cards_url
    assert_equal cards_path, path
    follow_redirect!
    assert_match name, response.body
    assert_select 'td', text: name
  end

  test 'cards interface should handle delete' do
    log_in_as(@user)
    get cards_path
    # Delete a post.
    assert_select 'a[aria-label=?]', 'delete'
    first_item = Card.first
    assert_difference 'Card.count', -1 do
      delete card_path(first_item)
    end
  end
end
