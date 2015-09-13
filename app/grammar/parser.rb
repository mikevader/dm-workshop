require 'polyglot'
require 'treetop'
require_relative 'node_extensions'

class Parser
  Treetop.load 'dmwql.treetop'
  @@parser = ArithmeticParser.new
  
  def self.parse data
    #data = %Q/#{ARGV[0]}/

    tree = @@parser.parse(data, consume_all_input: true)
    #clean_tree(tree)

    if tree.nil?
      cursorline = " " * (@@parser.failure_column-1) + "^"
      raise Exception, "Parse error occured: #{@@parser.failure_reason}\n#{data}\n#{cursorline}"
      #puts "input: #{data}"
      #puts @@parser.failure_reason
      #puts @@parser.failure_line
      #puts @@parser.failure_column
    else
      return tree.num
    end
  end
  
  def clean_tree(root_node)
    return if(root_node.elements.nil?)
    root_node.elements.delete_if { |node| node.class.name == "Treetop::Runtime::SyntaxNode" }
    root_node.elements.each { |node| clean_tree(node) }
  end
end


input = %Q/#{ARGV[0]}/
puts Parser.parse(input)

