module Search
  class SearchEngine
    def initialize(entity_class)
      @entity_class = entity_class
    end

    def search(search_string, all_on_empty = true)
      result = @entity_class.none
      normalized = search_string
      error = nil
      begin
        if search_string.blank?
          if all_on_empty
            result = @entity_class.all
          else
            #result = []
          end
        else
          result, normalized = search_entities(search_string)
        end
      rescue ParseSearchError => e
        error = e.parse_error
      end

      return result, normalized, error
    end

    private
    def search_entities(search)
      if search
        builder = @entity_class.new_search_builder
        search = Parser.new.parse(search, builder)

        query = @entity_class
        builder.joins.each do |join|
          query = query.joins(join)
        end
        query = query.where(search)

        unless builder.orders.empty?
          order = builder.orders.first
          query = query.reorder("#{order[:field]} #{order[:direction]}")
          builder.orders.drop(1).each do |order|
            query = query.order("#{order[:field]} #{order[:direction]}")
          end
        end
        return query, builder.search
      else
        return all, search
      end
    end
  end
end
