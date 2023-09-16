require 'test_helper'

class CardImportTest < ActiveSupport::TestCase

  setup do
    @user = users(:michael)
  end

  test 'should import obgam' do
    path = File.join(file_fixture_path, 'monsters.xml')
    file = Rack::Test::UploadedFile.new(path, 'text/xml')
    importer = CardImport.new(@user, monsters_file: file)
    importer.import_monsters
    importer.save

    obgam = Monster.find_by_name('Obgam Sohn des Brogar')
    assert obgam, 'Did not find Obgam.'

    assert_not obgam.shared?
    assert_empty obgam.cite
    assert_equal 'Humanoid (dwarf)', obgam.monster_type
    assert_equal 'Medium', obgam.monster_size
    assert_equal 9, obgam.challenge
    assert_equal 4, obgam.bonus # calculated value from cr
    assert_equal '16', obgam.armor_class
    assert_equal 170, obgam.hit_points
    assert_equal '25 ft.', obgam.speed
    assert_equal 16, obgam.strength
    assert_equal 9, obgam.dexterity
    assert_equal 17, obgam.constitution
    assert_equal 12, obgam.intelligence
    assert_equal 18, obgam.wisdom
    assert_equal 7, obgam.charisma
    assert_includes obgam.saving_throws, 'con'
    assert_includes obgam.saving_throws, 'wis'
    assert_not_includes obgam.saving_throws, 'str'
    assert_includes obgam.damage_resistances, 'poison'
    assert_includes obgam.cond_immunities, 'charmed'
    assert_equal 'Rogolan, Undercommon', obgam.languages

    skills_expected = %w(Deception Perception)

    skills_expected.each do |skill_name|
      assert obgam.skills.find_by_name(skill_name), "Could not find skill '#{skill_name}'"
      # FIXME: not yet implemented
      # assert_equal value, obgam.skills.where(name: key).value
    end

    assert_equal 'darkvision: 120 ft', obgam.senses

    traits = {}
    traits[:dwarven_resilience] = {
        name: 'Dwarven Resilience',
        description: 'Dwarves have adv. on saving throws against poison.'}
    traits[:spellcasting] = {
        name: 'Spellcasting',
        description: 'Obgam is a l0th-level spellcaster. Its spellcasting ability is Wisdom (spell save DC 16, +7 to hit with s pell attacks). Obgam has the following druid spells prepared:<br> Cantrips (at will): Shillelagh, Thorn Whip, Frostbite<br> lst level (4 slots): Entangle, Cure Wounds, Healing Word, Faerie Fire, Absorb Elements<br> 2nd level (3 slots): Flame Blade, Hold Person, Flaming Sphere<br> 3rd level (3 slots): Meld into Stone, Protection from Energy, Erupting Earth<br> 4th level (3 slots): Blight, Ice Storm, Stoneskin<br> 5th level (2 slots): Conjure Elemental<br> 6th level (1 slot): Bones of the Earth'
    }

    traits.each do |_key, trait|
      assert obgam.traits.find_by_title(trait[:name]), "Could not find trait '#{trait[:name]}'"
      assert_equal trait[:description], obgam.traits.find_by_title(trait[:name]).description
    end

    assert_equal 1, obgam.actions.size
    warhammer = obgam.actions.first

    assert_equal 'Warhammer', warhammer.title
    assert_equal '<i>Melee Weapon Attack:</i> +7 to hit, reach 5ft., one target. <i>Hit:</i> 15 (2d8 + 3) bludgeoning damage.', warhammer.description


  end

  test 'should import goblin' do
    path = File.join(file_fixture_path, 'monsters.xml')
    file = Rack::Test::UploadedFile.new(path, 'text/xml')
    importer = CardImport.new(@user, monsters_file: file)
    importer.import_monsters
    importer.save

    goblin = Monster.find_by_name 'Goblin'
    assert goblin, 'Did not find Goblin.'

    assert goblin.shared?
    assert_equal 'MM 123', goblin.cite
    assert_equal 'Goblin', goblin.monster_type
    assert_equal 'huge', goblin.monster_size
    assert_equal 2, goblin.bonus
    assert_equal '13 (natural armor)', goblin.armor_class
    assert_equal 105, goblin.hit_points
    assert_equal '40 ft.', goblin.speed
    assert_equal 8, goblin.strength
    assert_equal 14, goblin.dexterity
    assert_equal 10, goblin.constitution
    assert_equal 10, goblin.intelligence
    assert_equal 8, goblin.wisdom
    assert_equal 8, goblin.charisma
    assert_equal 0.25, goblin.challenge
    assert_equal 'Common, Goblin', goblin.languages

    skills_expected = %w(Stealth Perception)

    skills_expected.each do |skill_name|
      assert goblin.skills.find_by_name(skill_name), "Could not find skill '#{skill_name}'"
      # FIXME: not yet implemented
      # assert_equal value, goblin.skills.where(name: key).value
    end

    assert_equal 'darkvision: 60 ft, passive Perception: 9', goblin.senses

    assert_equal 1, goblin.traits.size
    keen_smell = goblin.traits.first
    assert_equal 'Keen Smell', keen_smell.title
    assert_equal 'The bear has advantage on Wisdom (Perception) checks that rely on smell.', keen_smell.description

    assert_equal 2, goblin.actions.size
    scimitar = goblin.actions.first
    shortbow = goblin.actions.second

    assert_equal 'Scimitar', scimitar.title
    assert_equal '<i>Melee Weapon Attack:</i> +4 to hit, reach 5ft., one target. <i>Hit:</i> 1d6 + 2 slashing damage.', scimitar.description
    assert_equal 'Shortbow', shortbow.title
    assert_equal '<i>Ranged Weapon Attack:</i> +4 to hit, range 80/320ft., one target. <i>Hit:</i> 1d6 + 2 piercing damage.', shortbow.description
  end

  test 'should import Alarm' do
    skip("Alarm no longer in test set")
    path = File.join(file_fixture_path, 'spells.xml')
    file = Rack::Test::UploadedFile.new(path, 'text/xml')
    importer = CardImport.new(@user, spells_file: file)
    importer.import_spells
    importer.save

    alarm = Spell.find_by_name 'Alarm'
    assert alarm, 'Did not find Alarm spell.'

    assert_equal 'Alarm', alarm.name
    assert alarm.ritual?
    assert alarm.shared?
    assert_equal 'Page: 211  Players Handbook', alarm.cite
    assert_equal 1, alarm.level
    assert_equal 'Abjuration', alarm.school
    assert_equal 2, alarm.hero_classes.size
    assert_includes alarm.hero_classes.first.name, 'Ranger'
    assert_includes alarm.hero_classes.second.name, 'Wizard'
    assert_equal '1 Minute', alarm.casting_time
    assert_equal '30 feet', alarm.range
    assert_equal 'V, S, M (a tiny bell and a piece of fine silver wire)', alarm.components
    assert_equal '8 hours', alarm.duration
    assert_equal 'You set an alarm against unwanted intrusion.
        Choose a door, a window, or an area within range that is no larger than a 20-foot cube. Until the spell ends, an alarm alerts you whenever a tiny or larger creature touches or enters the warded area. When you cast the spell, you can designate creatures that won’t set off the alarm. You also choose whether the alarm is mental or audible.

        A mental alarm alerts you with a ping in your mind if you are within 1 mile of the warded area. This ping awakens you if you are sleeping.
        An audible alarm produces the sound of a hand bell for 10 seconds within 60 feet.', alarm.description
  end

  test 'should import Magic Missile' do
    path = File.join(file_fixture_path, 'spells.xml')
    file = Rack::Test::UploadedFile.new(path, 'text/xml')
    importer = CardImport.new(@user, spells_file: file)
    importer.import_spells
    importer.save

    magic_missile = Spell.find_by_name 'Magic Missile'
    assert magic_missile, 'Did not find Magic Missile spell'

    assert_equal 'Magic Missile', magic_missile.name
    assert_not magic_missile.ritual?
    assert_not magic_missile.shared?
    assert_nil magic_missile.cite
    assert_equal 1, magic_missile.level
    assert_equal 'evocation', magic_missile.school
    assert_equal 2, magic_missile.hero_classes.size
    assert_includes magic_missile.hero_classes.first.name, 'Sorcerer'
    assert_includes magic_missile.hero_classes.second.name, 'Wizard'
    assert_equal '1 action', magic_missile.casting_time
    assert_equal '120 feet', magic_missile.range
    assert_equal 'V, S', magic_missile.components
    assert_equal 'Instantaneous', magic_missile.duration
    assert_equal 'You create three glowing darts of magical force. Each dart hits a creature of your choice that you can see within range. A dart deals 1d4 + 1 force damage to its target. The darts all strike simultaneously, and you can direct them to hit one creature or several.<br>', magic_missile.short_description
    assert_equal 'When you cast this spell using a spell slot of 2nd level or higher, the spell creates one more dart for each slot level above 1st.', magic_missile.athigherlevel
    assert_equal 'You create three glowing darts of magical force. Each dart hits a creature of your choice that you can see within range. A dart deals 1d4 + 1 force damage to its target. The darts all strike simultaneously, and you can direct them to hit one creature or several.<br>
        <b>At Higher Levels.</b> When you cast this spell using a spell slot of 2nd level or higher, the spell creates one more dart for each slot level above 1st.', magic_missile.description
  end

  test 'should overwrite spells correctly' do

  end

  test 'should import free form card frenzy' do
    path = File.join(file_fixture_path, 'cards.xml')
    file = Rack::Test::UploadedFile.new(path, 'text/xml')
    importer = CardImport.new(@user, cards_file: file)
    importer.import_cards
    importer.save

    frenzy = Card.find_by_name 'Frenzy'
    assert frenzy, 'Did not find Frenzy card'
    assert frenzy.shared?
    assert_equal 'PH 49', frenzy.cite
    assert_equal 'icon-white-book', frenzy.icon
    assert_equal 'indigo', frenzy.color
    assert_equal 'icon-class-barbarian', frenzy.badges
    assert_equal 'subtitle | Barbarian feature
        rule
        fill | 1
        text | You can go into a frenzy when you rage. If you do so, for the duration of your rage you can make a single melee weapon attack as a bonus action on each of your turns after this one. When your rage ends, you suffer one level of exhaustion.
        fill | 2', frenzy.contents
  end

  test 'should import item Schutzring' do
    path = File.join(file_fixture_path, 'items.xml')
    file = Rack::Test::UploadedFile.new(path, 'text/xml')
    importer = CardImport.new(@user, items_file: file)
    importer.import_items
    importer.save

    schutzring = Item.find_by_name 'Schutzring'
    assert schutzring, 'Did not find Schutzring'
    assert schutzring.shared?
    assert_equal 'DMH 191', schutzring.cite
    assert_equal 'Ring', schutzring.category.name
    assert_equal 'Rare', schutzring.rarity.name
    assert_equal true, schutzring.attunement?
    assert_equal 'Du bekommst einen Bonus von +1 auf deine AC und Rettungswürfe solange du den Ring trägst.', schutzring.description
  end
end
