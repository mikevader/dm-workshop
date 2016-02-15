class SearchEngine2
  def initialize(entity_class, current_user)
    name_space = "#{entity_class}Policy::Scope".constantize
    @entity_class = name_space.new(current_user, entity_class).resolve
  end
  
  def search(search_string, all_on_empty = true)
    result = @entity_class.none
    error = nil
    begin
      if search_string.blank?
        if all_on_empty
          result = @entity_class.all
        else
          result = []
        end
      else
        result = search_entities(search_string)
      end
    rescue ParseSearchError => e
      puts e.message
      puts e.backtrace.join("\n")
      # Rails.logger.error e.message
      # Rails.logger.error e.backtrace.join("\n")
      error = e.parse_error
    end

    return result.to_a, error
  end

  def search_entities(search)
    if search
      builder = @entity_class.new_search_builder
      search = Parser.new.parse(search, builder)

      query = @entity_class
      builder.joins.each do |join|
        query = query.joins(join)
      end
      query = query.where(search)
      builder.orders.each do |order|
        query = query.order(order)
      end
      query.distinct
    else
      all
    end
  end

end