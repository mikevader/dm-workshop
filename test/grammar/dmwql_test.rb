require 'test_helper'

class DmwqlTest < ActiveSupport::TestCase
  
  def setup
    @builder = SearchBuilder.new
    @builder.add_field 'name'
    @builder.add_field 'level'
    @builder.add_field 'class'
    @builder.add_field 'school'
    @parser = Parser.new
  end
  
  test "should work with empty input" do
    assert_equal "level = 5", @parser.parse("level = 5", @builder)
  end

  test "should work with string" do
    assert_equal "name LIKE 'asdf'", @parser.parse("name = 'asdf'", @builder)
  end

  test "should work with asterix in string" do
    assert_equal "name LIKE 'hello%'", @parser.parse("name = 'hello*'", @builder)
  end

  test "should work with AND and OR" do
    assert_equal "name LIKE 'Bane' AND level = 5", @parser.parse("name = 'Bane' AND level = 5", @builder)
    assert_equal "name LIKE 'Bane' AND level = 5", @parser.parse("name = 'Bane' and level = 5", @builder)
    assert_equal "name LIKE 'Bane' OR level = 5", @parser.parse("name = 'Bane' Or level = 5", @builder)
    assert_equal "name LIKE 'Bane' OR level = 5", @parser.parse("name = 'Bane' oR level = 5", @builder)
  end

  test "should work with groups" do
    assert_equal "name LIKE 'Bane' AND (level = 5 OR school LIKE 'necromancy')",
      @parser.parse("name = 'Bane' and ( level = 5 or school = 'necromancy')", @builder)
  end

  test "should work with all comparators" do
    assert_equal "name LIKE 'Bane'", @parser.parse("name = 'Bane'", @builder)
    assert_equal "level = 5", @parser.parse("level = 5", @builder)
    assert_equal "level != 5", @parser.parse("level   !=    5", @builder)
    assert_equal "level < 5", @parser.parse("level < 5", @builder)
    assert_equal "level > 5", @parser.parse("level > 5", @builder)
    assert_equal "level <= 5", @parser.parse("level <= 5", @builder)
    assert_equal "level >= 5", @parser.parse("level >= 5", @builder)
  end
  
  test "should work with in" do
    assert_equal "class in ('Bard')", @parser.parse("class in ('Bard')", @builder)
    assert_equal "class in ('Cleric', 'Bard')", @parser.parse("class in ('Cleric', 'Bard')", @builder)
  end
  
  test "should work with relations" do
    builder = SearchBuilder.new
    builder.add_relation "classes", "hero_classes.name", "hero_classes"
    
    assert_equal "hero_classes.name in ('Bard')",
    @parser.parse("classes in ('Bard')", builder)
    
    assert builder.joins.first == :hero_classes
  end

end