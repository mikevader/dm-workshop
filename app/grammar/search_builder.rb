class SearchBuilder
  
  def initialize
    @fields = {}
    @tags = {}
    @relations = {}
    @joins = []
    @orders = []
  end
  
  def add_field(field_name, substitution = field_name)
    @fields[field_name.to_sym] = substitution
  end

  def add_tag(field_name, substitution = field_name)
    @tags[field_name.to_sym] = substitution
  end
  
  def add_relation(relation_name, substitution, join_table)
    @relations[relation_name.to_sym] = {substitution: substitution, join_table: join_table.to_sym}
  end
  
  def add_ordering(order_name)
    @orders << query_id(order_name)
  end
  
  def query_id(id)
    if @fields[id.to_sym]
      @fields[id.to_sym]
    elsif @relations[id.to_sym]
      @joins << @relations[id.to_sym][:join_table]
      @relations[id.to_sym][:substitution]
    else
      raise ParseSearchError.new("Field '#{id}' does not exist."), "Search contained query for unkown field '#{id}'."
    end
  end
  
  def joins
    return @joins
  end
  
  def orders
    if @orders.empty?
      @orders << :name
    end
    
    return @orders
  end



end