class CardImportTest < ActiveSupport::TestCase

  setup do
    @user = users(:michael)
  end

  test 'should import obgam' do
    path = File.join(fixture_path, 'monsters.xml')
    file = Rack::Test::UploadedFile.new(path, 'text/xml')
    importer = CardImport.new monsters_file: file
    importer.save(@user)

    obgam = Monster.find_by_name 'Obgam Sohn des Brogar'


    assert_equal 'Humanoid (dwarf)', obgam.monster_type
    assert_equal 'Medium', obgam.size
    assert_equal 9, obgam.bonus
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
    assert_equal 9, obgam.challenge
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
            description: 'Dwarves have adv. on saving throws against poison.' }
    traits[:spellcasting] = {
            name: 'Spellcasting',
            description: 'Obgam is a l0th-level spellcaster. Its spellcasting ability is Wisdom (spell save DC 16, +7 to hit with s pell attacks). Obgam has the following druid spells prepared:<br> Cantrips (at will): Shillelagh, Thorn Whip, Frostbite<br> lst level (4 slots): Entangle, Cure Wounds, Healing Word, Faerie Fire, Absorb Elements<br> 2nd level (3 slots): Flame Blade, Hold Person, Flaming Sphere<br> 3rd level (3 slots): Meld into Stone, Protection from Energy, Erupting Earth<br> 4th level (3 slots): Blight, Ice Storm, Stoneskin<br> 5th level (2 slots): Conjure Elemental<br> 6th level (1 slot): Bones of the Earth'
        }

    traits.each do |key, trait|
      assert obgam.traits.find_by_title(trait[:name]), "Could not find trait '#{trait[:name]}'"
      assert_equal trait[:description], obgam.traits.find_by_title(trait[:name]).description
    end

    assert_equal 1, obgam.actions.size
    warhammer = obgam.actions.first

    assert_equal 'Warhammer', warhammer.title
    assert_equal '<i>Melee Weapon Attack:</i> +7 to hit, reach 5ft., one target. <i>Hit:</i> 15 (2d8 + 3) bludgeoning damage.', warhammer.description


  end

  test 'should import goblin' do
    path = File.join(fixture_path, 'monsters.xml')
    file = Rack::Test::UploadedFile.new(path, 'text/xml')
    importer = CardImport.new monsters_file: file
    importer.save(@user)

    goblin = Monster.find_by_name 'Goblin'


    assert_equal 'Goblin', goblin.monster_type
    assert_equal 'huge', goblin.size
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

end