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


end