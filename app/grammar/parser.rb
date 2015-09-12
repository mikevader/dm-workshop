require 'polyglot'
require 'treetop'
require_relative 'node_extensions'


def clean_tree(root_node)
  return if(root_node.elements.nil?)
  root_node.elements.delete_if { |node| node.class.name == "Treetop::Runtime::SyntaxNode" }
  root_node.elements.each { |node| clean_tree(node) }
end

input = %Q/#{ARGV[0]}/
Treetop.load 'dmwql.treetop'
parser = ArithmeticParser.new
#Treetop.load 'parantes.treetop'
#parser = ParenLanguageParser.new
tree = parser.parse(input, consume_all_input: true)
#clean_tree(tree)

if tree.nil?
  puts "input: #{input}"
  puts parser.failure_reason
  puts parser.failure_line
  puts parser.failure_column
else
  puts tree.num
end


