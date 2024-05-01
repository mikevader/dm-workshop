require 'polyglot'
require 'treetop'

module Grammar
  module Parser
    class Parser
      def initialize
        grammar_file = Rails.root.join("lib/grammar/dmwql.treetop").to_s
        Treetop.load grammar_file
        @parser = DmwqlParser.new
      end

      def parse(data, builder = SearchBuilder::SearchBuilder.new)
        return '*' if data.nil?

        tree = @parser.parse(data, root: :search)

        if tree.nil?
          parser_error = @parser.failure_reason
          cursorline = "#{' ' * (@parser.failure_column - 1)}^"
          raise Grammar::Parser::ParseSearchError.new(parser_error), "Parse error occured: #{@parser.failure_reason}\n#{data}\n#{cursorline}"
        else
          tree.query_string(builder)
          builder.query.squish
        end
      end

      def clean_tree(root_node)
        return if root_node.elements.nil?

        root_node.elements.delete_if { |node| node.instance_of?(::Treetop::Runtime::SyntaxNode) }
        root_node.elements.each { |node| clean_tree(node) }
      end
    end

    class ParseSearchError < ArgumentError
      attr_accessor :parse_error

      def initialize(parse_error)
        super(parse_error)
        @parse_error = parse_error
      end
    end
  end
end
