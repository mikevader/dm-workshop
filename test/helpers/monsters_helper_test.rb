require 'test_helper'

class MonstersHelperTest < ActionView::TestCase

  test "should calculate skill modifier from ability" do
    monster = monsters(:shadow_demon)
    skill = skills(:arcana)
    
    assert_equal 2, skill_modifier(monster, skill)
  end

  test "should add proficiency modifier for proficient skills" do
    monster = monsters(:shadow_demon)
    skill = skills(:stealth)
    
    assert_equal 5, skill_modifier(monster, skill)
  end

  test "should raise exception if monster or skill is nil" do
    monster = monsters(:shadow_demon)
    skill = skills(:stealth)
    assert_raises ArgumentError do
      skill_modifier(monster, nil)
    end
    
    assert_raises ArgumentError do
      skill_modifier(nil, skill)
    end
  end
  
  test "should calculate saving throws modifier" do
    monster = monsters(:shadow_demon)
    monster.saving_throws = ["dex"]
    
    assert_equal 5, saving_throw_modifier(monster, "dex")
  end

  test "should calculate proficient saving throws modifier" do
    monster = monsters(:shadow_demon)
    assert_equal 1, saving_throw_modifier(monster, "con")
  end

  test "saving throws list should include abilities abbr." do
    monster = monsters(:shadow_demon)
    assert monster.saving_throws.include?("str")
    assert monster.saving_throws.include?("dex")
    assert_not monster.saving_throws.include?("con")
    assert_not monster.saving_throws.include?("int")
    assert_not monster.saving_throws.include?("wis")
    assert_not monster.saving_throws.include?("cha")
  end

end