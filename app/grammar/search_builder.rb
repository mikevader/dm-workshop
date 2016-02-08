class SearchBuilder

  def initialize(&block)
    @fields = {}
    @tags = {}
    @relations = {}
    @joins = []
    @orders = []

    @tree_root = lambda { return @current_node.call }
    @current_node = lambda { return "" }

    self.instance_eval(&block) if block_given?
  end

  def configure_field(field_name, substitution = field_name)
    @fields[field_name.to_sym] = substitution
  end

  def configure_tag(field_name, substitution = field_name)
    @tags[field_name.to_sym] = substitution
  end

  def configure_relation(relation_name, substitution, join_table)
    @relations[relation_name.to_sym] = {substitution: substitution, join_table: join_table.to_sym}
  end

  def query_id(id)
    if @fields[id.to_sym]
      @fields[id.to_sym]
    elsif @relations[id.to_sym]
      @joins << @relations[id.to_sym][:join_table]
      @relations[id.to_sym][:substitution]
    else
      raise ParseSearchError.new("Field '#{id}' does not exist."), "Search contained query for unknown field '#{id}'."
    end
  end

  def joins
    @joins
  end

  def orders
    if @orders.empty?
      @orders << :name
    end
    @orders
  end

  def add_comp_clause(field, operator, value)
    if operator == '~'
      value = "%#{value.downcase.gsub('\'', '').strip}%"
    else
      value = "#{value.downcase.gsub('\'', '').strip.gsub(/\*/, '%')}"
    end

    @current_node = lambda { return "LOWER(#{query_id(field)}) LIKE '#{value}'" }

    self
  end

  def add_group_clause(field, values)
    values.tr!('()', '')
    query = values.split(',').map(&:strip).map { |x| surround_string_with_quotes_if_necessary(x) }.join(', ')
    query = '(' + query + ')'

    @current_node = lambda { return "#{query_id(field)} IN #{query}" }
  end

  def and(and_second)
    and_first = @current_node
    and_second = and_second.instance_variable_get(:@current_node)
    @tree_root = lambda { return "#{and_first.call} AND #{and_second.call}" }
  end

  def or(or_second)
    or_first = @current_node
    or_second = or_second.instance_variable_get(:@current_node)
    @tree_root = lambda { return "#{or_first.call} OR #{or_second.call}" }
  end

  def parenthesis(search)
    prev_root = @tree_root
    @tree_root = lambda { return "( #{prev_root.call} )" }
    self
  end

  def query
    @tree_root.call
  end

  private
  def surround_string_with_quotes_if_necessary(string)
    if string =~ /\d/ or string =~ /'.*'/
      string
    else
      "'#{string}'"
    end
  end
end