require 'test_helper'

class MonstersInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "monsters interface should handle invalid input" do
    log_in_as(@user)
    get monsters_path
    #assert_select 'div.pagination'
    # Invalid submission
    assert_no_difference 'Monster.count' do
      post monsters_path, monster: { name: "" }
    end
    assert_select 'div#error_explanation'
  end

  test 'monsters interface should handle valid input' do
    log_in_as(@user)
    get monsters_path
    # Valid submission
    name = "heroblade"
    assert_difference 'Monster.count', 1 do
      get new_monster_path, nil, referer: monsters_url
      post monsters_path, monster: { name: name, size: "small", monster_type: "humanoid", armor_class: "15 (leather armor, shield)", hit_points: 7, strength: 8, dexterity: 14, constitution: 10, intelligence: 10, wisdom: 8, charisma: 8 }
    end
    assert_redirected_to monsters_url
    follow_redirect!
    assert_match name, response.body
    assert_select 'td', text: name
  end

  test 'monsters interface should handle delete' do
    log_in_as(@user)
    get monsters_path
    # Delete a post.
    assert_select 'a[aria-label=?]', 'delete'
    first_item = Monster.paginate(page: 1).first
    assert_difference 'Monster.count', -1 do
      delete monster_path(first_item)
    end
  end
end
