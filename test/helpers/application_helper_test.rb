require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  
  test "full title helper" do
    assert_equal full_title, "Dungeon Masters Workshop"
    assert_equal full_title("Help"), "Help | Dungeon Masters Workshop"
  end
  
end