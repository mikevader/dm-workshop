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
      first_operand
    end
  end
  
  class Expression < Treetop::Runtime::SyntaxNode
    def query_string(builder)
      if defined? query
        query.query_string(builder)
      else
        builder.clone.parenthesis(search.query_string(builder.clone))
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
  
  class ArrayComparison < Treetop::Runtime::SyntaxNode
    def query_string(builder)
      #return "#{builder.query_id(id.text_value)} in #{group.query_string(builder)}"
      builder.add_group_clause id.text_value, group.query_string
    end
  end
  
  class Group < Treetop::Runtime::SyntaxNode
    def query_string
      query = '(' + surround_string_with_quotes_if_necessary(literal.text_value)
      
      second.elements.each do |node|
        query = query + ', ' + surround_string_with_quotes_if_necessary(node.literal.text_value)
      end

      query + ')'
    end
  end

  class Comparison < Treetop::Runtime::SyntaxNode
    def query_string(builder)
      if defined? str_comp
        str_comp.query_string(id.text_value, builder)
        # return "LOWER(#{builder.query_id(id.text_value)}) #{str_comp.query_string(builder)}"
      else
        non_str_comp.query_string(id.text_value, builder)
        # return builder.query_id(id.text_value) + ' ' + non_str_comp.query_string(builder)
      end
    end
  end
  
  class StringComparison < Treetop::Runtime::SyntaxNode
    def query_string(field, builder)
      operator = if op.text_value == '~'
                   '~'
                 else
                   '='
                 end

      builder.add_str_comp_clause field, operator, value.text_value
      # if op.text_value == '~'
      #   return "LIKE '%#{value.text_value.downcase.gsub('\'','').strip}%'"
      # else
      #   return "LIKE '#{value.text_value.downcase.gsub('\'','').strip.gsub(/\*/, '%')}'"
      # end
    end
  end
  
  class NonStringComparison < Treetop::Runtime::SyntaxNode
    def query_string(field, builder)
      operator = op.text_value
      value2 = value.text_value

      builder.add_non_str_comp_clause field, operator, value2
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
