
module Dmwql
  class Search < Treetop::Runtime::SyntaxNode
    def query_string(builder)
      builder
      text = first.query_string(builder)
      second.elements.each do |node|
        text += " " + node.union.text_value.upcase + " "
        text += node.next.query_string(builder)
      end
      
      return text
    end
  end
  
  class Expression < Treetop::Runtime::SyntaxNode
    def query_string(builder)
      if defined? query
        return query.query_string(builder)
      else
        return '(' + search.query_string(builder) + ')'
      end
    end
  end
  
  class Query < Treetop::Runtime::SyntaxNode
    def query_string(builder)
      if defined? comp
        return comp.query_string(builder)
      else
        return group.query_string(builder)
      end
    end
  end
  
  class ArrayComparison < Treetop::Runtime::SyntaxNode
    def query_string(builder)
      return "#{builder.query_id(id.text_value)} in #{group.query_string(builder)}"
    end
  end
  
  class Group < Treetop::Runtime::SyntaxNode
    def query_string(builder)
      query = '(' + surround_string_with_quotes_if_necessary(literal.text_value)
      
      second.elements.each do |node|
        query = query + ', ' + surround_string_with_quotes_if_necessary(node.literal.text_value)
      end
      
      return query + ')'
    end
  end

  class Comparison < Treetop::Runtime::SyntaxNode
    def query_string(builder)
      if defined? str_comp
        return "LOWER(#{builder.query_id(id.text_value)}) #{str_comp.query_string(builder)}"
      else
        return builder.query_id(id.text_value) + ' ' + non_str_comp.query_string(builder)
      end
    end
  end
  
  class StringComparison < Treetop::Runtime::SyntaxNode
    def query_string(builder)
      if op.text_value == '~'
        return "LIKE '%#{value.text_value.downcase.gsub('\'','').strip}%'"
      else
        return "LIKE '#{value.text_value.downcase.gsub('\'','').strip.gsub(/\*/, '%')}'"
      end
    end
  end
  
  class NonStringComparison < Treetop::Runtime::SyntaxNode
    def query_string(builder)
      return op.text_value + ' ' + value.text_value.sub('true', "'t'").sub('false', "'f'")
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
