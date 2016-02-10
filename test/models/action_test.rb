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

  test "type should set correct accessors" do
    @action.action_type = 'legendary'
    assert @action.legendary?
  end

  test "text should be equal to description of it is no special action" do
    assert_equal @action.description, @action.text
  end

  test "text should contain prefix for melee weapon attacks" do
    @action.melee = true
    exp = "<i>Melee Weapon Attack:</i> #{@action.description}"
    assert_equal exp, @action.text
  end

  test "text should contain prefix for ranged weapon attacks" do
    @action.ranged = true
    exp = "<i>Ranged Weapon Attack:</i> #{@action.description}"
    assert_equal exp, @action.text
  end

  test "text should contain prefix for all weapon attacks" do
    @action.melee = true
    @action.ranged = true
    exp = "<i>Melee or Ranged Weapon Attack:</i> #{@action.description}"
    assert_equal exp, @action.text
  end
end
