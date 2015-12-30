require 'test_helper'

class SpellsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "spell interface" do
    log_in_as(@user)
    get spells_path
    # Invalid submission
    assert_no_difference 'Spell.count' do
      post spells_path, spell: { name: "", level: 0, school: "" }
    end
    assert_select 'div#error_explanation'
    # Valid submission
    description = "This spell really ties the room together"
    assert_difference 'Spell.count', 1 do
      post spells_path, spell: { name: "Slow", level: 3, school: "transmutation", description: description }
    end
    assert_redirected_to spells_url
    follow_redirect!
    assert_match description, response.body
    # Delete a post.
    assert_select 'a[aria-label=?]', 'delete'
    first_spell = @user.spells.paginate(page: 1).first
    assert_difference 'Spell.count', -1 do
      delete spell_path(first_spell)
    end
    # Visit a different user.
    get user_path(users(:archer))
    assert_select 'a[aria-label=?]', 'delete', count: 1
  end
end
