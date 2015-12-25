require 'test_helper'

class TraitTest < ActiveSupport::TestCase

  def setup
    @monster = monsters(:shadow_demon)
    @trait = @monster.traits.build(title: "Shadow Stealth", description: "While in dim light or darkness, the demon can take the Hide action as a bonus action.")
  end
  
  test "should be valid" do
    assert @trait.valid?
  end

  test "monster id should be present" do
    @trait.monster_id = nil
    assert_not @trait.valid?
  end

  test "title should be present" do
    @trait.title = "      "
    assert_not @trait.valid?
  end

  test "description should be present" do
    @trait.description = "     "
    assert_not @trait.valid?
  end
end
