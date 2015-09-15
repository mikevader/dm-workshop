require 'polyglot'
require 'treetop'
require 'ql_extensions'


class ParseSearchError < ArgumentError
  attr_accessor :parse_error
  
  def initialize(parse_error)
    @parse_error = parse_error
  end
end

class Parser

  def initialize
    grammar_file = File.join(File.expand_path(Rails.root), 'app', 'grammar', 'dmwql.treetop')
    Treetop.load grammar_file
    @parser = DmwqlParser.new
  end

  def parse(data, builder = SearchBuilder.new)
    return "*" if data.nil?

    tree = @parser.parse(data, root: :search)

    if tree.nil?
      parser_error = @parser.failure_reason
      cursorline = " " * (@parser.failure_column-1) + "^"
      raise ParseSearchError.new(parser_error), "Parse error occured: #{@parser.failure_reason}\n#{data}\n#{cursorline}"
    else
      query_string = tree.query_string(builder).squish
      
      return query_string
    end
  end

  def clean_tree(root_node)
    return if(root_node.elements.nil?)
    root_node.elements.delete_if { |node| node.class.name == "Treetop::Runtime::SyntaxNode" }
    root_node.elements.each { |node| clean_tree(node) }
  end
end
