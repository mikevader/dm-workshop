class SearchBuilder

  def initialize(&block)
    @fields = {}
    @tags = {}
    @relations = {}
    @joins = []
    @orders = []

    @tree_root = nil

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
      @orders << :name
    end
    @orders
  end

  def is_tag?(id)
    @tags.include? id
  end

  def add_str_comp_clause(field, operator, value)
    value = value.downcase.gsub('\'', '').strip

    if operator == '~'
      value = "%#{value}%"
    else
      value = "#{value.gsub(/\*/, '%')}"
    end

    @tree_root = lambda { return "LOWER(#{query_id(field)}) LIKE '#{value}'" }
    self
  end

  def add_non_str_comp_clause(field, operator, value)
    value = value.sub('true', "'t'").sub('false', "'f'")

    @tree_root = lambda { return "#{query_id(field)} #{operator} #{value}" }
    self
  end

  def add_group_clause(field, values)
    values.tr!('()', '')

    if is_tag? field.to_sym
      tags = values.split(',').map(&:strip)
      clazz = @tags[field.to_sym]
      ids = clazz.tagged_with(tags, any: true).to_a.map(&:id)

      @tree_root = lambda { return "id IN (#{ids.join(', ')})" }
    else
      query = values.split(',').map(&:strip).map { |x| surround_string_with_quotes_if_necessary(x) }.join(', ')
      query = '(' + query + ')'

      @tree_root = lambda { return "#{query_id(field)} IN #{query}" }
    end

    self
  end

  def and(and_second)
    and_first = @tree_root
    and_second = and_second.instance_variable_get(:@tree_root)
    @tree_root = lambda { return "#{and_first.call} AND #{and_second.call}" }
    self
  end

  def or(or_second)
    or_first = @tree_root
    or_second = or_second.instance_variable_get(:@tree_root)
    @tree_root = lambda { return "#{or_first.call} OR #{or_second.call}" }
    self
  end

  def parenthesis(search)
    search_root = search.instance_variable_get(:@tree_root)
    @tree_root = lambda { return "( #{search_root.call} )" }
    self
  end

  def query
    unless @tree_root.nil?
      @tree_root.call
    else
      ''
    end
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