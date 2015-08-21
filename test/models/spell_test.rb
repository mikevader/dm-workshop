require 'test_helper'

class SpellTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:michael)
    @spell = @user.spells.build(name: "Speak with Plants", level: 3, school: "transmutation")
  end
  
  test "should be valid" do
    assert @spell.valid?
  end
  
  test "user id should be present" do
    @spell.user_id = nil
    assert_not @spell.valid?
  end
  
  test "name should be present" do
    @spell.name = "    "
    assert_not @spell.valid?
  end

  test "school should be present" do
    @spell.school = "    "
    assert_not @spell.valid?
  end
  
  test "level should be present" do
    @spell.level = nil
    assert_not @spell.valid?
  end

  test "level should be greater or equal than 0" do
    @spell.level = -1
    assert_not @spell.valid?
  end

  test "level should be lesser or equal than 9" do
    @spell.level = 10
    assert_not @spell.valid?
  end

  test "order should be alphabetically" do
    assert_equal spells(:bane), Spell.first
  end
end
