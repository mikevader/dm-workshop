require 'test_helper'

class MonsterTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:michael)
    @monster = @user.monsters.build(name: "Goblin", size: "small", monster_type: "humanoid", armor_class: "15 (leather armor, shield)", hit_points: 7, strength: 8, dexterity: 14, constitution: 10, intelligence: 10, wisdom: 8, charisma: 8)
  end

  test "should be valid" do
    assert @monster.valid?
  end
  
  test "user id should be present" do
    @monster.user_id = nil
    assert_not @monster.valid?
  end
  
  test "name should be present" do
    @monster.name = "    "
    assert_not @monster.valid?
  end
  
  test "ability should be between 0 and 100" do
    @monster.dexterity = 0
    assert_not @monster.valid?
    @monster.dexterity = 100
    assert_not @monster.valid?
  end

  test "ability modifier should be calculated for all abilities" do
    assert_equal -1, @monster.strength_modifier
    assert_equal 2, @monster.dexterity_modifier
    assert_equal 0, @monster.constitution_modifier
    assert_equal 0, @monster.intelligence_modifier
    assert_equal -1, @monster.wisdom_modifier
    assert_equal -1, @monster.charisma_modifier
  end

  test "ability modifier should be calculated from 1 to 30" do
    @monster.strength = 1
    assert_equal -5, @monster.strength_modifier
    @monster.strength = 2
    assert_equal -4, @monster.strength_modifier
    @monster.strength = 3
    assert_equal -4, @monster.strength_modifier
    @monster.strength = 4
    assert_equal -3, @monster.strength_modifier
    @monster.strength = 5
    assert_equal -3, @monster.strength_modifier
    @monster.strength = 6
    assert_equal -2, @monster.strength_modifier
    @monster.strength = 7
    assert_equal -2, @monster.strength_modifier
    @monster.strength = 8
    assert_equal -1, @monster.strength_modifier
    @monster.strength = 9
    assert_equal -1, @monster.strength_modifier
    @monster.strength = 10
    assert_equal 0, @monster.strength_modifier
    @monster.strength = 11
    assert_equal 0, @monster.strength_modifier
    @monster.strength = 12
    assert_equal 1, @monster.strength_modifier
    @monster.strength = 13
    assert_equal 1, @monster.strength_modifier
    @monster.strength = 14
    assert_equal 2, @monster.strength_modifier
    @monster.strength = 15
    assert_equal 2, @monster.strength_modifier
    @monster.strength = 16
    assert_equal 3, @monster.strength_modifier
    @monster.strength = 17
    assert_equal 3, @monster.strength_modifier
    @monster.strength = 18
    assert_equal 4, @monster.strength_modifier
    @monster.strength = 19
    assert_equal 4, @monster.strength_modifier
    @monster.strength = 20
    assert_equal 5, @monster.strength_modifier
    @monster.strength = 21
    assert_equal 5, @monster.strength_modifier
    @monster.strength = 22
    assert_equal 6, @monster.strength_modifier
    @monster.strength = 23
    assert_equal 6, @monster.strength_modifier
    @monster.strength = 24
    assert_equal 7, @monster.strength_modifier
    @monster.strength = 25
    assert_equal 7, @monster.strength_modifier
    @monster.strength = 26
    assert_equal 8, @monster.strength_modifier
    @monster.strength = 27
    assert_equal 8, @monster.strength_modifier
    @monster.strength = 28
    assert_equal 9, @monster.strength_modifier
    @monster.strength = 29
    assert_equal 9, @monster.strength_modifier
    @monster.strength = 30
    assert_equal 10, @monster.strength_modifier
  end
  
end
