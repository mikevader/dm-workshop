require 'test_helper'

class FreeFormsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "cards interface should handle invalid input" do
    log_in_as(@user)
    get free_forms_path
    #assert_select 'div.pagination'
    # Invalid submission
    assert_no_difference 'Card.count' do
      post free_forms_path, params: { free_form: { name: "" } }
    end
    assert_select 'div#error_explanation'
  end

  test 'cards interface should handle valid input' do
    log_in_as(@user)
    get free_forms_path
    # Valid submission
    name = "heroblade"
    assert_difference 'Card.count', 1 do
      get new_free_form_path, nil, referer: free_forms_url
      post free_forms_path, params: { free_form: { name: name, icon: 'white-book', color: 'indigo', contents: 'subtitle | Rogue feature' } }
    end

    assert_redirected_to free_forms_url
    follow_redirect!
    assert_match name, response.body
    assert_select 'td', text: name
  end

  test 'cards interface should handle delete' do
    log_in_as(@user)
    get free_forms_path
    # Delete a post.
    assert_select 'a[aria-label=?]', 'delete'
    first_item = Card.first
    assert_difference 'Card.count', -1 do
      delete free_form_path(first_item)
    end
  end
end
