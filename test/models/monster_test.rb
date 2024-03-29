require 'test_helper'

class MonsterTest < ActiveSupport::TestCase
  include CommonCardTest

  setup do
    @user = users(:michael)
    @card = @monster = @user.monsters.build(name: 'Goblin',
                                    source: sources(:dnd),
                                    card_size: '35x50',
                                    monster_size: 'small',
                                    monster_type: 'humanoid',
                                    armor_class: '15 (leather armor, shield)',
                                    hit_points: 7,
                                    strength: 8,
                                    dexterity: 14,
                                    constitution: 10,
                                    intelligence: 10,
                                    wisdom: 8,
                                    charisma: 8)
  end

  test 'skills should be addible' do
    @monster.skills << skills(:insight)
    @monster.skills << skills(:arcana)
    assert @monster.valid?
    assert_equal 2, @monster.skills.size
  end

  test 'ability should be between 0 and 100' do
    @monster.dexterity = 0
    assert_not @monster.valid?
    @monster.dexterity = 100
    assert_not @monster.valid?
  end

  test 'ability modifier should be calculated for all abilities' do
    assert_equal (-1), @monster.strength_modifier
    assert_equal 2, @monster.dexterity_modifier
    assert_equal 0, @monster.constitution_modifier
    assert_equal 0, @monster.intelligence_modifier
    assert_equal (-1), @monster.wisdom_modifier
    assert_equal (-1), @monster.charisma_modifier
  end

  test 'ability modifier should be calculated from 1 to 30' do
    @monster.strength = 1
    assert_equal (-5), @monster.strength_modifier
    @monster.strength = 2
    assert_equal (-4), @monster.strength_modifier
    @monster.strength = 3
    assert_equal (-4), @monster.strength_modifier
    @monster.strength = 4
    assert_equal (-3), @monster.strength_modifier
    @monster.strength = 5
    assert_equal (-3), @monster.strength_modifier
    @monster.strength = 6
    assert_equal (-2), @monster.strength_modifier
    @monster.strength = 7
    assert_equal (-2), @monster.strength_modifier
    @monster.strength = 8
    assert_equal (-1), @monster.strength_modifier
    @monster.strength = 9
    assert_equal (-1), @monster.strength_modifier
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

  test 'adding saving throws ability should add bonus to modifier' do
    @monster.saving_throws = ['str']
    assert_includes @monster.saving_throws, 'str'
  end

  test 'adding damage vulnerabilities' do
    @monster.damage_vulnerabilities = ['fire']
    assert_includes @monster.damage_vulnerabilities, 'fire'
  end

  test 'shadow deamon should have correct damange and condition attributes' do
    shadow_demon = cards(:shadow_demon)

    assert_includes shadow_demon.saving_throws, 'str'
    assert_includes shadow_demon.saving_throws, 'dex'
    assert_includes shadow_demon.damage_vulnerabilities, 'radiant'
    assert_includes shadow_demon.damage_resistances, 'acid'
    assert_includes shadow_demon.damage_resistances, 'fire'
    assert_includes shadow_demon.damage_resistances, 'necrotic'
    assert_includes shadow_demon.damage_resistances, 'thunder'
    assert_includes shadow_demon.damage_immunities, 'cold'
    assert_includes shadow_demon.damage_immunities, 'lightning'
    assert_includes shadow_demon.damage_immunities, 'poison'
    assert_includes shadow_demon.cond_immunities, 'exhaustion'
    assert_includes shadow_demon.cond_immunities, 'grappled'
    assert_includes shadow_demon.cond_immunities, 'paralyzed'
    assert_includes shadow_demon.cond_immunities, 'petrified'
    assert_includes shadow_demon.cond_immunities, 'poisoned'
    assert_includes shadow_demon.cond_immunities, 'prone'
    assert_includes shadow_demon.cond_immunities, 'restrained'
  end

  test 'monster should have no action initially' do
    assert @monster.actions.empty?
  end


  test 'monster should have shortsword action' do
    @monster.actions.build(action_type: 'action', title: 'Shortsword', description: "Melee Weapon Attack: +4 to hit, reach 5 ft., one target. Hit: 5 (1d6 + 2) piercing damage.", melee: true)

    assert_equal 1, @monster.actions.size
  end

  test 'monster should have no traits initially' do
    assert @monster.traits.empty?
  end


  test 'monster should have nimble escape trait' do
    @monster.traits.build(title: 'Nimble Escape', description: 'The goblin can take the Disengage or Hide action as a bonus action on each of its turns.')

    assert_equal 1, @monster.traits.size
  end

  test 'should calculate XP from challenge rating' do
    assert_equal '5\'000', Monster.xp_for_cr(9)
    assert_equal '100', Monster.xp_for_cr(0.5)
    assert_equal '200', Monster.xp_for_cr(1)
    assert_equal '200', Monster.xp_for_cr(1.0)
    assert_equal '50', Monster.xp_for_cr(0.25)
    assert_equal '25', Monster.xp_for_cr(0.125)
    assert_equal '155\'000', Monster.xp_for_cr(30)
    assert_equal '18\'000', Monster.xp_for_cr(17)
    assert_equal '0', Monster.xp_for_cr(0)
  end

  test 'should print pretty challenge rating' do
    assert_equal '9', Monster.challenge_pretty(9)
    assert_equal '1/2', Monster.challenge_pretty(0.5)
  end
end
