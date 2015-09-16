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
end
