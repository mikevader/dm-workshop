require 'test_helper'

class SearchBuilderTest < ActiveSupport::TestCase
  setup do
    @builder = SearchBuilder.new do
      configure_field 'name'
      configure_field 'level'
      configure_field 'class'
      configure_field 'school'
      configure_field 'ritual'
    end
  end

  test 'should work with empty build' do
    query = @builder.query

    assert_equal '', query
  end

  test 'should work with or - and chains' do
    @builder.add_comp_clause('class', '=', 'foo').or(@builder.clone.add_comp_clause('name', '=', 'hello')).and(@builder.clone.add_comp_clause('class', '=', 'world'))

    query = @builder.query

    assert_equal "LOWER(class) LIKE 'foo' OR LOWER(name) LIKE 'hello' AND LOWER(class) LIKE 'world'", query
  end

  test 'should work with parenthesis' do
    @builder.add_comp_clause('class', '=', 'foo').or(@builder.clone.parenthesis(@builder.clone.add_comp_clause('name', '=', 'hello').and(@builder.clone.add_comp_clause('class', '=', 'world'))))

    query = @builder.query

    assert_equal "LOWER(class) LIKE 'foo' OR ( LOWER(name) LIKE 'hello' AND LOWER(class) LIKE 'world' )", query
  end

  test 'should work with AND union' do
    @builder.add_comp_clause('name', '=', 'hello').and(@builder.clone.add_comp_clause('class', '=', 'world'))

    query = @builder.query

    assert_equal "LOWER(name) LIKE 'hello' AND LOWER(class) LIKE 'world'", query
  end

  test 'should work with OR union' do
    @builder.add_comp_clause('name', '=', 'hello').or(@builder.clone.add_comp_clause('class', '=', 'world'))

    query = @builder.query

    assert_equal "LOWER(name) LIKE 'hello' OR LOWER(class) LIKE 'world'", query
  end

  test 'should generate basic query' do
    @builder.add_comp_clause 'name', '=', 'hello'

    query = @builder.query

    assert_equal "LOWER(name) LIKE 'hello'", query
  end

  test 'should generate fuzzy query' do
    @builder.add_comp_clause 'name', '~', 'hello'

    query = @builder.query

    assert_equal "LOWER(name) LIKE '%hello%'", query
  end

  test 'should generate group query' do
    @builder.add_group_clause 'name', '(hello, world)'

    query = @builder.query

    assert_equal "name IN ('hello', 'world')", query
  end
end
