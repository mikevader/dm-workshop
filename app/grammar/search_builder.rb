class SearchBuilder

  def initialize(&block)
    @fields = {}
    @tags = {}
    @relations = {}
    @joins = []
    @orders = []

    @tree_root = nil

    @normalized_search = nil

    @normalized_orders = []

    self.instance_eval(&block) if block_given?
  end

  def configure_field(field_name, substitution = field_name)
    @fields[field_name.to_sym] = substitution
  end

  def configure_tag(field_name, clazz)
    @tags[field_name.to_sym] = clazz
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
      # @orders << {field: 'name', field: 'ASC'}
    end
    @orders
  end

  def add_str_comp_clause(field, operator, value)
    value = value.downcase.gsub('\'', '').strip

    if operator == '~'
      new_value = "%#{value}%"
    else
      new_value = "#{value.gsub(/\*/, '%')}"
    end

    @tree_root = lambda { return "LOWER(#{query_id(field)}) LIKE '#{new_value}'" }
    @normalized_search = lambda { return "#{field} #{operator} '#{value}'" }
    self
  end

  def add_non_str_comp_clause(field, operator, value)
    value = value.sub('true', "'t'").sub('false', "'f'")

    @tree_root = lambda { return "#{query_id(field)} #{operator} #{value}" }
    @normalized_search = lambda { return "#{field} #{operator} #{value}" }
    self
  end

  def order_by(field, direction)
    direction_sym = (direction.downcase == 'desc') ? 'desc' : 'asc'
    @orders << {field: query_id(field), direction: direction_sym}
    @normalized_orders << {field: field, direction: direction_sym}
    self
  end

  def add_group_clause(field, values)
    values.tr!('()', '')

    query = values.split(',').map(&:strip).map { |x| surround_string_with_quotes_if_necessary(x) }.join(', ')
    query = '(' + query + ')'

    if is_tag? field.to_sym
      tags = values.split(',').map(&:strip)
      clazz = @tags[field.to_sym]
      ids = clazz.tagged_with(tags, any: true).to_a.map(&:id)

      if ids.empty?
        ids << -1
      end


      @tree_root = lambda { return "id IN (#{ids.join(', ')})" }
    else
      if is_string_in_query? query
        @tree_root = lambda { return "LOWER(#{query_id(field)}) IN #{query.downcase}" }
      else
        @tree_root = lambda { return "#{query_id(field)} IN #{query}" }
      end
    end

    @normalized_search = lambda { return "#{field} IN #{query}" }

    self
  end

  def and(second_builder)
    and_first = @tree_root
    and_second = second_builder.instance_variable_get(:@tree_root)
    @tree_root = lambda { return "#{and_first.call} AND #{and_second.call}" }

    norm_or_first = @normalized_search
    norm_or_second = second_builder.instance_variable_get(:@normalized_search)
    @normalized_search = lambda { return "#{norm_or_first.call} AND #{norm_or_second.call}" }
    self
  end

  def or(second_builder)
    or_first = @tree_root
    or_second = second_builder.instance_variable_get(:@tree_root)
    @tree_root = lambda { return "#{or_first.call} OR #{or_second.call}" }

    norm_or_first = @normalized_search
    norm_or_second = second_builder.instance_variable_get(:@normalized_search)
    @normalized_search = lambda { return "#{norm_or_first.call} OR #{norm_or_second.call}" }
    self
  end

  def parenthesis(search)
    search_root = search.instance_variable_get(:@tree_root)
    @tree_root = lambda { return "( #{search_root.call} )" }

    normalize_root = search.instance_variable_get(:@normalized_search)
    @normalized_search = lambda { return "(#{normalize_root.call})" }
    self
  end

  def query
    unless @tree_root.nil?
      @tree_root.call
    else
      ''
    end
  end

  def search
    unless @normalized_search.nil?
      @normalized_search.call + normalized_order
    else
      ''
    end
  end

  private

  def normalized_order
    return '' if @normalized_orders.empty?

    " ORDER BY #{ @normalized_orders.map { |order| "#{order[:field]} #{order[:direction]}" }.join(', ') }"
  end

  def is_tag?(id)
    @tags.include? id
  end

  def is_string_in_query?(query_string)
    query_string =~ /'/
  end

  def surround_string_with_quotes_if_necessary(string)
    if string =~ /\d/ or string =~ /'.*'/
      string
    else
      "'#{string}'"
    end
  end
end