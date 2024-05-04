module Grammar
  module SearchBuilder
    class SearchBuilder
      attr_reader :joins

      def initialize(&block)
        @fields = {}
        @tags = {}
        @relations = {}
        @joins = []
        @orders = []

        @tree_root = nil

        @normalized_search = nil

        @normalized_orders = []

        instance_eval(&block) if block_given?
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
          raise Parser::ParseSearchError.new("Field '#{id}' does not exist."), "Search contained query for unknown field '#{id}'."
        end
      end

      def orders
        if @orders.empty?
          # @orders << {field: 'name', field: 'ASC'}
        end
        @orders
      end

      def add_str_comp_clause(field, operator, value)
        value = value.downcase.delete('\'').strip

        new_value = if operator == '~'
                      "%#{value}%"
                    else
                      value.tr('*', '%').to_s
                    end

        @tree_root = -> { return "LOWER(#{query_id(field)}) LIKE '#{new_value}'" }
        @normalized_search = -> { return "#{field} #{operator} '#{value}'" }
        self
      end

      def add_non_str_comp_clause(field, operator, value)
        value = value.sub('true', "'t'").sub('false', "'f'")

        @tree_root = -> { return "#{query_id(field)} #{operator} #{value}" }
        @normalized_search = -> { return "#{field} #{operator} #{value}" }
        self
      end

      def order_by(field, direction)
        direction_sym = direction.downcase == 'desc' ? 'desc' : 'asc'
        @orders << {field: query_id(field), direction: direction_sym}
        @normalized_orders << {field: field, direction: direction_sym}
        self
      end

      def add_group_clause(field, values)
        values.tr!('()', '')

        query = values.split(',').map(&:strip).map { |x| surround_string_with_quotes_if_necessary(x) }.join(', ')
        query = "(#{query})"

        if tag? field.to_sym
          tags = values.split(',').map(&:strip)
          clazz = @tags[field.to_sym]
          ids = clazz.tagged_with(tags, any: true).to_a.map(&:id)

          ids << -1 if ids.empty?


          @tree_root = -> { return "id IN (#{ids.join(', ')})" }
        else
          @tree_root = if string_in_query? query
                         -> { return "LOWER(#{query_id(field)}) IN #{query.downcase}" }
                       else
                         -> { return "#{query_id(field)} IN #{query}" }
                       end
        end

        @normalized_search = -> { return "#{field} IN #{query}" }

        self
      end

      def and(second_builder)
        and_first = @tree_root
        and_second = second_builder.instance_variable_get(:@tree_root)
        @tree_root = -> { return "#{and_first.call} AND #{and_second.call}" }

        norm_or_first = @normalized_search
        norm_or_second = second_builder.instance_variable_get(:@normalized_search)
        @normalized_search = -> { return "#{norm_or_first.call} AND #{norm_or_second.call}" }
        self
      end

      def or(second_builder)
        or_first = @tree_root
        or_second = second_builder.instance_variable_get(:@tree_root)
        @tree_root = -> { return "#{or_first.call} OR #{or_second.call}" }

        norm_or_first = @normalized_search
        norm_or_second = second_builder.instance_variable_get(:@normalized_search)
        @normalized_search = -> { return "#{norm_or_first.call} OR #{norm_or_second.call}" }
        self
      end

      def parenthesis(search)
        search_root = search.instance_variable_get(:@tree_root)
        @tree_root = -> { return "( #{search_root.call} )" }

        normalize_root = search.instance_variable_get(:@normalized_search)
        @normalized_search = -> { return "(#{normalize_root.call})" }
        self
      end

      def query
        if @tree_root.nil?
          ''
        else
          @tree_root.call
        end
      end

      def search
        if @normalized_search.nil?
          ''
        else
          @normalized_search.call + normalized_order
        end
      end

      private

      def normalized_order
        return '' if @normalized_orders.empty?

        " ORDER BY #{@normalized_orders.map { |order| "#{order[:field]} #{order[:direction]}" }.join(', ')}"
      end

      def tag?(id)
        @tags.include? id
      end

      def string_in_query?(query_string)
        query_string =~ /'/
      end

      def surround_string_with_quotes_if_necessary(string)
        if string =~ /\d/ || string =~ /'.*'/
          string
        else
          "'#{string}'"
        end
      end
    end
  end
end
