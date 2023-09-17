require 'test_helper'

class SearchEngineTest < ActiveSupport::TestCase

  setup do
    @standard_search_prefix = "SELECT \"cards\".* FROM \"cards\""
    @standard_search_postfix = "\"cards\".\"name\" ASC"
    @search_engine = Search::SearchEngine.new(Card)
    @search_engine_for_spells = Search::SearchEngine.new(Spell)
  end

  test 'empty search should search for all per default' do
    query, human_readable_query, error = @search_engine.search('')

    assert_equal(surround_pre_and_postfix,
                 query.to_sql)
    assert_equal("",
                 human_readable_query)
    assert_nil(error)
  end

  test 'empty search should search for none if set to false' do
    assert_search_with_normalized_query(
        '',
        '',
        'SELECT "cards".* FROM "cards" WHERE (1=0) ORDER BY "cards"."name" ASC',
        nil
    )
  end

  test 'union keywords and/or should work in searches' do
    assert_search_with_normalized_query(
        "name ~ bane AND (level = 5 OR school = necromancy)",
        "name ~ 'bane' AND (level = 5 OR school = 'necromancy')",
        surround_pre_and_postfix("LOWER(cards.name) LIKE '%bane%' AND ( cards.level = 5 OR LOWER(cards.school) LIKE 'necromancy' )"),
        nil
    )
  end

  test 'parenthesis should work to group clauses' do
    assert_search_with_normalized_query(
        "(type = 'Monster' or type = 'Spell') and name ~ 'Orc'",
        "(type = 'monster' OR type = 'spell') AND name ~ 'orc'",
        surround_pre_and_postfix("( LOWER(cards.type) LIKE 'monster' OR LOWER(cards.type) LIKE 'spell' ) AND LOWER(cards.name) LIKE '%orc%'"),
        nil
    )
  end

  test 'basic query should work' do
    assert_search_with_normalized_query(
        "name = 'hello'",
        "name = 'hello'",
        surround_pre_and_postfix("LOWER(cards.name) LIKE 'hello'"),
        nil
    )
  end

  test 'wrong fields should produce errors' do
    assert_search_with_normalized_query(
        "namer ~ 'cunning'",
        "namer ~ 'cunning'",
        'SELECT "cards".* FROM "cards" WHERE (1=0) ORDER BY "cards"."name" ASC',
        "Field 'namer' does not exist."
    )
  end

  test 'wrong operators should produce errors' do
    assert_search_with_normalized_query(
        "namer & 'cunning'",
        "namer & 'cunning'",
        'SELECT "cards".* FROM "cards" WHERE (1=0) ORDER BY "cards"."name" ASC',
        "Expected one of \" \", [0-9a-zA-Z_\\-\\*\\&], [ \\t\\n\\r] at line 1, column 9 (byte 9) after "
    )
  end

  test 'should generate fuzzy query' do
    assert_search_with_normalized_query(
        "name ~ 'hello'",
        "name ~ 'hello'",
        surround_pre_and_postfix("LOWER(cards.name) LIKE '%hello%'"),
        nil
    )
  end

  test 'IN keyword should work doing a group search' do
    assert_search_with_normalized_query(
        "name IN ('hello', 'world')",
        "name IN ('hello', 'world')",
        surround_pre_and_postfix("LOWER(cards.name) IN ('hello', 'world')"),
        nil
    )
  end

  test 'tags should work over specific ids' do
    spell = cards('fireball')
    spell.tag_list.add('jdf')
    spell.save

    assert_search_with_normalized_query(
        'tags in (jdf)',
        "tags IN ('jdf')",
        surround_pre_and_postfix("id IN (#{spell.id})"),
        nil
    )
  end

  test 'numbers should work with groups' do
    assert_search_with_normalized_query(
        'level in (1, 5)',
        'level IN (1, 5)',
        surround_pre_and_postfix('cards.level IN (1, 5)'),
        nil
    )
  end

  test 'relations should work with equal operator' do
    assert_search_with_normalized_query(
        Spell,
        'classes = Bard',
        "classes = 'bard'",
        "SELECT \"cards\".* FROM \"cards\" INNER JOIN \"cards_hero_classes\" ON \"cards_hero_classes\".\"card_id\" = \"cards\".\"id\" INNER JOIN \"hero_classes\" ON \"hero_classes\".\"id\" = \"cards_hero_classes\".\"hero_class_id\" WHERE \"cards\".\"type\" = 'Spell' AND (LOWER(hero_classes.name) LIKE 'bard') ORDER BY \"cards\".\"name\" ASC",
        nil
    )
  end

  test 'relations should work with groups' do
    assert_search_with_normalized_query(
        Spell,
        'classes in (Bard)',
        "classes IN ('Bard')",
        "SELECT \"cards\".* FROM \"cards\" INNER JOIN \"cards_hero_classes\" ON \"cards_hero_classes\".\"card_id\" = \"cards\".\"id\" INNER JOIN \"hero_classes\" ON \"hero_classes\".\"id\" = \"cards_hero_classes\".\"hero_class_id\" WHERE \"cards\".\"type\" = 'Spell' AND (LOWER(hero_classes.name) IN ('bard')) ORDER BY \"cards\".\"name\" ASC",
        nil
    )
  end

  test 'boolean fields should work' do
    assert_search_with_normalized_query(
        'ritual = true',
        "ritual = 't'", # TODO: Validate if this is really the expected result and not 'ritual = true'
        surround_pre_and_postfix("cards.ritual = 't'"),
        nil
    )
  end

  test 'should order by id' do
    assert_search_with_normalized_query(
        "school = 'necromancy' order by name",
        "school = 'necromancy' ORDER BY name asc",
        surround_prefix("LOWER(cards.school) LIKE 'necromancy'", 'cards.name asc'),
        nil
    )
  end

  test 'should order by multiple ids' do
    assert_search_with_normalized_query(
        'level > 5 ORDER BY level, school',
        'level > 5 ORDER BY level asc, school asc',
        surround_prefix('cards.level > 5', 'cards.level asc, cards.school asc'),
        nil
    )
  end

  test 'all standard fields should work in search queries' do
    assert_search_for_standard_field('name = Cunning', "LOWER(cards.name) LIKE 'cunning'")
    assert_search_for_standard_field('type = Spell', "LOWER(cards.type) LIKE 'spell'")
    assert_search_for_standard_field('tags in (7g)', 'id IN (-1)')
  end

  test 'all FreeForm fields should work in search queries' do
    assert_search_for_standard_field('color = Black', "LOWER(cards.color) LIKE 'black'")
  end

  test 'all Item fields should work in search queries' do
    assert_search_for_standard_field('attunement = false', "cards.attunement = 'f'")
    assert_search(Item, 'category = Armor', "SELECT \"cards\".* FROM \"cards\" INNER JOIN \"categories\" ON \"categories\".\"id\" = \"cards\".\"category_id\" WHERE \"cards\".\"type\" = 'Item' AND (LOWER(categories.name) LIKE 'armor') ORDER BY \"cards\".\"name\" ASC")
    assert_search(Item, 'rarity = Uncommon', "SELECT \"cards\".* FROM \"cards\" INNER JOIN \"rarities\" ON \"rarities\".\"id\" = \"cards\".\"rarity_id\" WHERE \"cards\".\"type\" = 'Item' AND (LOWER(rarities.name) LIKE 'uncommon') ORDER BY \"cards\".\"name\" ASC")
  end

  test 'all Spell fields should work in search queries' do
    assert_search_for_standard_field('ritual = true', "cards.ritual = 't'")
    assert_search_for_standard_field('school = Necromancy', "LOWER(cards.school) LIKE 'necromancy'")
    assert_search_for_standard_field('level = 5', 'cards.level = 5')
    assert_search_for_standard_field('concentration = true', "cards.concentration = 't'")
    assert_search_for_standard_field("duration = '8 hours'", "LOWER(cards.duration) LIKE '8 hours'")
    assert_search_for_standard_field("castingTime = '1 Action'", "LOWER(cards.casting_time) LIKE '1 action'")
    assert_search(Spell, 'classes IN (Paladin, Warlock)', "SELECT \"cards\".* FROM \"cards\" INNER JOIN \"cards_hero_classes\" ON \"cards_hero_classes\".\"card_id\" = \"cards\".\"id\" INNER JOIN \"hero_classes\" ON \"hero_classes\".\"id\" = \"cards_hero_classes\".\"hero_class_id\" WHERE \"cards\".\"type\" = 'Spell' AND (LOWER(hero_classes.name) IN ('paladin', 'warlock')) ORDER BY \"cards\".\"name\" ASC")
  end

  test 'all Monster fields should work in search queries' do
    assert_search_for_standard_field('str = 10', 'cards.strength = 10')
    assert_search_for_standard_field('dex = 10', 'cards.dexterity = 10')
    assert_search_for_standard_field('con = 10', 'cards.constitution = 10')
    assert_search_for_standard_field('int = 10', 'cards.intelligence = 10')
    assert_search_for_standard_field('wis = 10', 'cards.wisdom = 10')
    assert_search_for_standard_field('cha = 10', 'cards.charisma = 10')
  end

  test 'all string operators should work in search queries' do
    assert_search_for_standard_field("name = Cunning", "LOWER(cards.name) LIKE 'cunning'")
    assert_search_for_standard_field("name = 'Cunning Word'", "LOWER(cards.name) LIKE 'cunning word'")
    assert_search_for_standard_field("name = 'Cunning'", "LOWER(cards.name) LIKE 'cunning'")
    assert_search_for_standard_field("name = '*Cunning'", "LOWER(cards.name) LIKE '%cunning'")
    assert_search_for_standard_field("name = 'Cunning*'", "LOWER(cards.name) LIKE 'cunning%'")
    assert_search_for_standard_field("name = '*Cunning*'", "LOWER(cards.name) LIKE '%cunning%'")
    assert_search_for_standard_field("name ~ Cunning", "LOWER(cards.name) LIKE '%cunning%'")
    assert_search_for_standard_field("name ~ 'Cunning Word'", "LOWER(cards.name) LIKE '%cunning word%'")
    assert_search_for_standard_field("name in (word, power)", "LOWER(cards.name) IN ('word', 'power')")
  end

  test 'all number operators should work in search queries' do
    assert_search_for_standard_field('level = 5', 'cards.level = 5')
    assert_search_for_standard_field('level != 5', 'cards.level != 5')
    assert_search_for_standard_field('level < 5', 'cards.level < 5')
    assert_search_for_standard_field('level <= 5', 'cards.level <= 5')
    assert_search_for_standard_field('level > 5', 'cards.level > 5')
    assert_search_for_standard_field('level >= 5', 'cards.level >= 5')
    assert_search_for_standard_field('level in (1, 3, 5)', 'cards.level IN (1, 3, 5)')
  end

  test 'all boolean operators should work in search queries' do
    assert_search_for_standard_field('ritual = true', "cards.ritual = 't'")
    assert_search_for_standard_field('ritual = false', "cards.ritual = 'f'")
    assert_search_for_standard_field("ritual = 't'", "LOWER(cards.ritual) LIKE 't'")
    assert_search_for_standard_field('ritual != true', "cards.ritual != 't'")
    assert_search_for_standard_field('ritual != false', "cards.ritual != 'f'")
  end

  test 'type clause should work with relation clause' do
    assert_search_with_normalized_query(
        "type = 'Spell' AND classes IN (sorcerer)",
        "type = 'spell' AND classes IN ('sorcerer')",
        "SELECT \"cards\".* FROM \"cards\" INNER JOIN \"cards_hero_classes\" ON \"cards_hero_classes\".\"card_id\" = \"cards\".\"id\" INNER JOIN \"hero_classes\" ON \"hero_classes\".\"id\" = \"cards_hero_classes\".\"hero_class_id\" WHERE (LOWER(cards.type) LIKE 'spell' AND LOWER(hero_classes.name) IN ('sorcerer')) ORDER BY \"cards\".\"name\" ASC",
        nil
    )
  end


  private
  def surround_pre_and_postfix(search_query = '', type = '')
    "#{surround_prefix(search_query, @standard_search_postfix, type)}"
  end

  def surround_prefix(search_query, order_by, type = '')
    if search_query.blank?
      "#{@standard_search_prefix} ORDER BY #{order_by}"
    else
      if type.blank?
        "#{@standard_search_prefix} WHERE (#{search_query}) ORDER BY #{order_by}"
      else
        "#{@standard_search_prefix} WHERE \"cards\".\"type\" IN ('#{type}') AND (#{search_query}) ORDER BY #{order_by}"
      end
    end
  end

  def assert_search_for_standard_field(search_query, expected_sql_query)
    expected_sql_query = surround_pre_and_postfix(expected_sql_query)
    assert_search(search_query, expected_sql_query)
  end

  def assert_search_for_field(for_type = Card, search_query, expected_sql_query)
    type_string = (for_type != Card) ? for_type.to_s : ''
    expected_sql_query = surround_pre_and_postfix(expected_sql_query, type_string)

    assert_search(for_type, search_query, expected_sql_query)
  end

  def assert_search(for_type = Card, given_query, expected_sql_query)
    assert_instance_of(Class, for_type)
    search_engine = Search::SearchEngine.new(for_type)

    query, _, error = search_engine.search(given_query, false)
    assert_nil(error, "Returned unexpected error: #{error}")
    assert_equal(
        expected_sql_query,
        query.to_sql
    )
  end

  def assert_search_with_normalized_query(
      for_type = Card,
      given_query,
      expected_normalized_query,
      expected_sql_query,
      expected_error
  )

    assert_instance_of(Class, for_type)
    search_engine = Search::SearchEngine.new(for_type)

    query, normalized_query, error = search_engine.search(given_query, false)
    sql_query = query.to_sql

    if expected_error.nil?
      assert_nil error
    else
      assert_equal(
          expected_error,
          error
      )
    end
    assert_equal(
        expected_normalized_query,
        normalized_query
    )
    assert_equal(
        expected_sql_query,
        sql_query
    )
  end
end
