# In file node_extensions.rb
module Arithmetic
  class AdditiveLiteral < Treetop::Runtime::SyntaxNode
    def num
      
      return second.elements.inject(first.num) { |sum, n| sum + n.multitive.num }
    end
  end
  
  class MultitiveLiteral < Treetop::Runtime::SyntaxNode
    def num
      return second.elements.inject(first.num) { |prod, n| prod * n.primary.num } 
    end
  end
  
  class PrimaryLiteral < Treetop::Runtime::SyntaxNode
    def num
      if defined? number
        number.num
      else
        additive.num
      end
    end
  end
  
  class NumberLiteral < Treetop::Runtime::SyntaxNode
    def num
      return text_value.to_f
    end
  end
end
