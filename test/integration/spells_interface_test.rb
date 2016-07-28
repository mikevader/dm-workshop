require 'test_helper'

class SpellsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "spell interface should handle invalid input" do
    log_in_as(@user)
    get spells_path
    # Invalid submission
    assert_no_difference 'Spell.count' do
      post spells_path, params: { spell: { name: "", level: 0, school: "" } }
    end
    assert_select 'div#error_explanation'
  end

  test 'spell interface should handle valid input' do
    log_in_as(@user)
    get spells_path
    # Valid submission
    description = "This spell really ties the room together"
    spell_name = "Slow"
    assert_difference 'Spell.count', 1 do
      get new_spell_path, nil, referer: spells_url
      post spells_path, params: { spell: {name: spell_name, level: 3, school: "transmutation", description: description } }
    end
    assert_redirected_to spells_url
    follow_redirect!
    assert_match spell_name, response.body
  end

  test 'spell interface should handle deletes' do
    log_in_as(@user)
    get spells_path
    # Delete a post.
    assert_select 'a[aria-label=?]', 'delete'
    first_spell = @user.spells.first
    assert_difference 'Spell.count', -1 do
      delete spell_path(first_spell)
    end
    # Visit a different user.
    get user_path(users(:archer))
    assert_select 'a[aria-label=?]', 'delete', count: 0
  end
end
