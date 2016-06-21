require 'test_helper'

class SkillTest < ActiveSupport::TestCase

  def setup
    @skill = Skill.new(name: 'Medicine', ability: 'Wis')
  end

  test 'should be valid' do
    assert @skill.valid?
  end

  test 'name should be present' do
    @skill.name = '    '
    assert_not @skill.valid?
  end

  test 'ability should be present' do
    @skill.ability = '      '
    assert_not @skill.valid?
  end
end
