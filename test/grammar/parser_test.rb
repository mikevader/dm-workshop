require 'test_helper'

class ParserTest < ActiveSupport::TestCase
  
  def setup
    @builder = SearchBuilder.new
    @builder.configure_field 'name'
    @builder.configure_field 'level'
    @builder.configure_field 'class'
    @builder.configure_field 'school'
    @builder.configure_field 'ritual'
    @builder.configure_tag 'tags', Spell
    @parser = Parser.new
  end
  
  test 'should work with empty input' do
    assert_equal 'level = 5', @parser.parse('level = 5', @builder.clone)
  end

  test 'should work with tags' do
    spell = cards('fireball')
    spell.tag_list.add('jdf')
    spell.tag_list.add('7g')
    spell.save

    assert_equal "id IN (#{spell.id})", @parser.parse('tags in (jdf)', @builder.clone)
    assert_equal "id IN (#{spell.id})", @parser.parse("tags in (7g)", @builder.clone)
  end

  test 'should work with string' do
    assert_equal "LOWER(name) LIKE 'asdf'", @parser.parse("name = 'asdf'", @builder.clone)
  end

  test 'should work with wildcards in string' do
    assert_equal "LOWER(name) LIKE 'asdf%'", @parser.parse("name = 'asdf*'", @builder.clone)
  end

  test 'should work with fuzzy string comparison' do
    assert_equal "LOWER(name) LIKE '%asdf%'", @parser.parse("name ~ 'asdf'", @builder.clone)
  end

  test 'should work with asterix in string' do
    assert_equal "LOWER(name) LIKE 'hello%'", @parser.parse("name = 'hello*'", @builder.clone)
  end

  test 'should work with whitespace less string without quotes' do
    assert_equal "LOWER(name) LIKE 'hello'", @parser.parse("name = hello", @builder.clone)
  end

  test 'should work with AND and OR' do
    assert_equal "LOWER(name) LIKE 'bane' AND level = 5", @parser.parse("name = 'Bane' AND level = 5", @builder.clone)
    assert_equal "LOWER(name) LIKE 'bane' AND level = 5", @parser.parse("name = 'Bane' and level = 5", @builder.clone)
    assert_equal "LOWER(name) LIKE 'bane' OR level = 5", @parser.parse("name = 'Bane' Or level = 5", @builder.clone)
    assert_equal "LOWER(name) LIKE 'bane' OR level = 5", @parser.parse("name = 'Bane' oR level = 5", @builder.clone)
  end

  test 'should work with several string searches ORed' do
    assert_equal "LOWER(name) LIKE 'bane' OR LOWER(name) LIKE 'quark'", @parser.parse("name = 'Bane' OR name = 'Quark'", @builder.clone)
    assert_equal "LOWER(name) LIKE 'bane' OR LOWER(name) LIKE 'quark'", @parser.parse("name = 'Bane' OR name = Quark", @builder.clone)
    assert_equal "LOWER(name) LIKE 'bane' OR LOWER(name) LIKE 'quark'", @parser.parse("name = Bane OR name = Quark", @builder.clone)
    assert_equal "LOWER(name) LIKE '%bane%' OR LOWER(name) LIKE '%quark%'", @parser.parse("name ~ Bane OR name ~ Quark", @builder.clone)
  end


  test 'should work with groups' do
    assert_equal "LOWER(name) LIKE 'bane' AND ( level = 5 OR LOWER(school) LIKE 'necromancy' )",
      @parser.parse("name = 'bane' and ( level = 5 or school = 'necromancy')", @builder.clone)
  end

  test 'should work with all comparators' do
    assert_equal "LOWER(name) LIKE 'bane'", @parser.parse("name = 'Bane'", @builder.clone)
    assert_equal "level = 5", @parser.parse("level = 5", @builder.clone)
    assert_equal "level != 5", @parser.parse("level   !=    5", @builder.clone)
    assert_equal "level < 5", @parser.parse("level < 5", @builder.clone)
    assert_equal "level > 5", @parser.parse("level > 5", @builder.clone)
    assert_equal "level <= 5", @parser.parse("level <= 5", @builder.clone)
    assert_equal "level >= 5", @parser.parse("level >= 5", @builder.clone)
  end
  
  test 'should work with in' do
    assert_equal "class IN ('Bard')", @parser.parse("class in ('Bard')", @builder.clone)
    assert_equal "class IN ('Cleric', 'Bard')", @parser.parse("class in ('Cleric', 'Bard')", @builder.clone)
  end

  test 'should work with in without quotes' do
    assert_equal "class IN ('Bard')", @parser.parse("class in (Bard)", @builder.clone)
    assert_equal "school IN ('transmutation', 'evocation')", @parser.parse("school in (transmutation, evocation)", @builder.clone)
    assert_equal "level IN (1, 2)",
                 @parser.parse("level IN (1, 2)", @builder.clone)
  end

  test 'should work with just a string' do
    assert_equal "LOWER(name) LIKE '%bard%'", @parser.parse("Bard", @builder.clone)
  end

  test 'should work with group of numbers' do
    assert_equal "level IN (1, 5)", @parser.parse("level in (1, 5)", @builder.clone)
  end

  test 'should work with relations' do
    builder = SearchBuilder.new
    builder.configure_relation "classes", "hero_classes.name", "hero_classes"
    
    assert_equal "hero_classes.name IN ('Bard')",
    @parser.parse("classes in ('Bard')", builder)
    
    assert builder.joins.first == :hero_classes
  end

  test 'should work with booleans' do
    assert_equal "ritual = 't'", @parser.parse("ritual = true", @builder.clone)
    assert_equal "ritual = 'f'", @parser.parse("ritual = false", @builder.clone)
  end
end
