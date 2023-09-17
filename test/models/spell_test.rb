require 'test_helper'

class SpellTest < ActiveSupport::TestCase
  include CommonCardTest

  setup do
    @user = users(:michael)
    @card = @spell = @user.spells.create(name: 'Speak with Plants',
                                 source: sources(:dnd),
                                 card_size: '25x35',
                                 level: 3,
                                 school: 'transmutation')
  end

  test 'school should be present' do
    @spell.school = '    '
    assert_not @spell.valid?
  end

  test 'level should be present' do
    @spell.level = nil
    assert_not @spell.valid?
  end

  test 'level should be greater or equal than 0' do
    @spell.level = -1
    assert_not @spell.valid?
  end

  test 'level should be lesser or equal than 9' do
    @spell.level = 10
    assert_not @spell.valid?
  end

  test 'classes should be unique' do
    @spell.hero_classes << hero_classes(:gunslinger)
    assert_raises(ActiveRecord::RecordNotUnique) do
      @spell.hero_classes << hero_classes(:gunslinger)
    end
  end

  test 'order should be alphabetically' do
    assert_equal cards(:bane), Spell.first
  end

  test 'should follow and unfollow a user' do
    fireball = cards(:fireball)
    bane = cards(:bane)
    gunslinger = hero_classes(:gunslinger)
    goliath = hero_classes(:goliath)

    assert_not fireball.hero_classes.include?(gunslinger)
    assert_not fireball.hero_classes.include?(goliath)
    assert_not goliath.spells.include?(bane)
    assert_not gunslinger.spells.include?(bane)

    fireball.hero_classes << gunslinger
    fireball.hero_classes << goliath

    assert goliath.spells.include?(fireball)
    assert gunslinger.spells.include?(fireball)

    goliath.spells << bane

    assert goliath.spells.count == 2

    bane.hero_classes.delete(goliath)
    assert_not goliath.spells.include?(bane)
  end
end
