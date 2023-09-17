require 'test_helper'

class FreeFormsInterfaceTest < ActionDispatch::IntegrationTest

  setup do
    @user = users(:michael)
    @source = sources(:dnd)
  end

  test 'cards interface should handle invalid input' do
    log_in_as(@user)
    get free_forms_path
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
    name = 'heroblade'
    assert_difference 'Card.count', 1 do
      get new_free_form_path, headers: { referer: free_forms_url }
      post free_forms_path,
           params: {
               free_form: {
                   name: name,
                   source_id: @source.id,
                   card_size: '25x50',
                   icon: 'white-book',
                   color: 'indigo',
                   contents: 'subtitle | Rogue feature' } }
    end

    assert_redirected_to free_forms_url
    follow_redirect!
    assert_match name, response.body
    assert_select 'td', text: name
  end

  test 'cards interface should search for all' do
    log_in_as(@user)
    get free_forms_path
    # Valid submission
    assert_select 'table.table' do
      assert_select 'tr', FreeForm.count + 1
    end
  end

  test 'cards interface should handle search for card by name' do
    log_in_as(@user)
    get free_forms_path, params: { search: 'name ~ cunning'}
    # Valid submission
    assert_select 'table.table' do
      assert_select 'tr', 2
      assert_select 'td', 'Cunning Action'
    end
  end

  test 'cards interface should handle incorrect search expression' do
    # skip 'Because of non suppressable backtraces'
    log_in_as(@user)
    get free_forms_path, params: { search: 'namer ~ cunning'}
    assert_select 'form#cards_search' do
      assert_select 'div.alert', "Field 'namer' does not exist."
    end

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
