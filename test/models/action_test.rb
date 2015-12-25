require 'test_helper'

class ActionTest < ActiveSupport::TestCase
  
  def setup
    @monster = monsters(:shadow_demon)
    @action = @monster.actions.build(title: "Shortsword", description: "Hit: +8, Damage: 1d10 +9")
  end

  test "should be valid" do
    assert @action.valid?
  end

  test "monster id should be present" do
    @action.monster_id = nil
    assert_not @action.valid?
  end

  test "title should be present" do
    @action.title = "      "
    assert_not @action.valid?
  end

  test "description should be present" do
    @action.description = "     "
    assert_not @action.valid?
  end
end
