module Dmwql
  class Search < Treetop::Runtime::SyntaxNode
    def query_string(builder)
      first_operand = first.query_string(builder)
      second.elements.each do |node|
        if node.union.text_value.upcase == 'AND'
          first_operand.and(node.next.query_string(builder.clone))
        else
          first_operand.or(node.next.query_string(builder.clone))
        end
      end

      if defined? sorting
        if defined? sorting.orderBy
          sorting.orderBy.query_string(builder)
        end
      end

      first_operand
    end
  end

  class StringSearch  < Treetop::Runtime::SyntaxNode
    def query_string(builder)
      builder.add_str_comp_clause 'name', '~', string.text_value
    end
  end
  
  class Expression < Treetop::Runtime::SyntaxNode
    def query_string(builder)
      if defined? query
        query.query_string(builder)
      else
        builder.parenthesis(expression.query_string(builder.clone))
      end
    end
  end
  
  class Query < Treetop::Runtime::SyntaxNode
    def query_string(builder)
      if defined? comp
        comp.query_string(builder)
      else
        group.query_string(builder)
      end
    end
  end
  
  class Group < Treetop::Runtime::SyntaxNode
    def query_string(builder)
      values = '(' << surround_string_with_quotes_if_necessary(literal.text_value)

      second.elements.each do |node|
        values << ', ' << surround_string_with_quotes_if_necessary(node.literal.text_value)
      end

      values << ')'

      builder.add_group_clause id.text_value, values
    end
  end

  class OrderBy < Treetop::Runtime::SyntaxNode
    def query_string(builder)
      add_order_by(builder, first)

      others.elements.each { |node| add_order_by(builder, node.order) }
    end

    def add_order_by(builder, node)
      field = node.id.text_value

      if defined? node.elements[1].direction
        direction = node.elements[1].direction.text_value
      else
        direction = 'ASC'
      end

      builder.order_by(field, direction)
    end
  end

  class StringComparison < Treetop::Runtime::SyntaxNode
    def query_string(builder)
      operator = if op.text_value == '~'
                   '~'
                 else
                   '='
                 end

      builder.add_str_comp_clause id.text_value, operator, value.text_value
      # if op.text_value == '~'
      #   return "LIKE '%#{value.text_value.downcase.gsub('\'','').strip}%'"
      # else
      #   return "LIKE '#{value.text_value.downcase.gsub('\'','').strip.gsub(/\*/, '%')}'"
      # end
    end
  end
  
  class BooleanComparison < Treetop::Runtime::SyntaxNode
    def query_string(builder)
      operator = op.text_value
      value2 = value.text_value

      builder.add_non_str_comp_clause id.text_value, operator, value2
    end
  end

  class NumberComparison < Treetop::Runtime::SyntaxNode
    def query_string(builder)
      operator = op.text_value
      value2 = value.text_value

      builder.add_non_str_comp_clause id.text_value, operator, value2
    end
  end

  class Treetop::Runtime::SyntaxNode
    def surround_string_with_quotes_if_necessary(string)
      unless string =~ /\d/ or string =~ /'.*'/
        return "'#{string}'"
      else
        return string
      end
    end
  end
end
