require 'test_helper'

class SearchBuilderTest < ActiveSupport::TestCase
  setup do
    @builder = Grammar::SearchBuilder::SearchBuilder.new do
      configure_field 'name'
      configure_field 'level'
      configure_field 'class'
      configure_field 'school'
      configure_field 'ritual'

      configure_tag 'tags', Spell
    end
  end

  test 'should work with tags' do
    spell = cards('fireball')
    spell.tag_list.add('jdf')
    spell.save

    @builder.add_group_clause('tags', '(jdf)')

    query = @builder.query
    search = @builder.search

    assert_equal "id IN (#{spell.id})", query
    assert_equal "tags IN ('jdf')", search
  end

  test 'should work with empty build' do
    query = @builder.query
    search = @builder.search

    assert_equal '', query
    assert_equal '', search
  end

  test 'should work with union and parenthesis' do
    @builder.add_str_comp_clause('name', '=', 'bane').and(@builder.clone.parenthesis(@builder.clone.add_non_str_comp_clause('level', '=', '5').or(@builder.clone.add_str_comp_clause('school', '=', 'necromancy'))))

    query = @builder.query
    search = @builder.search

    assert_equal "LOWER(name) LIKE 'bane' AND ( level = 5 OR LOWER(school) LIKE 'necromancy' )", query
    assert_equal "name = 'bane' AND (level = 5 OR school = 'necromancy')", search
  end

  test 'should work with or - and chains' do
    @builder.add_str_comp_clause('class', '=', 'foo').or(@builder.clone.add_str_comp_clause('name', '=', 'hello')).and(@builder.clone.add_str_comp_clause('class', '=', 'world'))

    query = @builder.query
    search = @builder.search

    assert_equal "LOWER(class) LIKE 'foo' OR LOWER(name) LIKE 'hello' AND LOWER(class) LIKE 'world'", query
    assert_equal "class = 'foo' OR name = 'hello' AND class = 'world'", search
  end

  test 'should work with parenthesis' do
    @builder.add_str_comp_clause('class', '=', 'foo').or(@builder.clone.parenthesis(@builder.clone.add_str_comp_clause('name', '=', 'hello').and(@builder.clone.add_str_comp_clause('class', '=', 'world'))))

    query = @builder.query
    search = @builder.search

    assert_equal "LOWER(class) LIKE 'foo' OR ( LOWER(name) LIKE 'hello' AND LOWER(class) LIKE 'world' )", query
    assert_equal "class = 'foo' OR (name = 'hello' AND class = 'world')", search
  end

  test 'should work with AND union' do
    @builder.add_str_comp_clause('name', '=', 'hello').and(@builder.clone.add_str_comp_clause('class', '=', 'world'))

    query = @builder.query
    search = @builder.search

    assert_equal "LOWER(name) LIKE 'hello' AND LOWER(class) LIKE 'world'", query
    assert_equal "name = 'hello' AND class = 'world'", search
  end

  test 'should work with OR union' do
    @builder.add_str_comp_clause('name', '=', 'hello').or(@builder.clone.add_str_comp_clause('class', '=', 'world'))

    query = @builder.query
    search = @builder.search

    assert_equal "LOWER(name) LIKE 'hello' OR LOWER(class) LIKE 'world'", query
    assert_equal "name = 'hello' OR class = 'world'", search
  end

  test 'should generate basic query' do
    @builder.add_str_comp_clause 'name', '=', 'hello'

    query = @builder.query
    search = @builder.search

    assert_equal "LOWER(name) LIKE 'hello'", query
    assert_equal "name = 'hello'", search
  end

  test 'should generate fuzzy query' do
    @builder.add_str_comp_clause 'name', '~', 'hello'

    query = @builder.query
    search = @builder.search

    assert_equal "LOWER(name) LIKE '%hello%'", query
    assert_equal "name ~ 'hello'", search
  end

  test 'should generate group query' do
    @builder.add_group_clause 'name', '(hello, world)'

    query = @builder.query
    search = @builder.search

    assert_equal "LOWER(name) IN ('hello', 'world')", query
    assert_equal "name IN ('hello', 'world')", search
  end
end
