class SearchEngine2
  def initialize(entity_class)
    @entity_class = entity_class
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
        result = @entity_class.search(search_string)
      end
    rescue ParseSearchError => e
      puts e.message
      puts e.backtrace.join("\n")
      # Rails.logger.error e.message
      # Rails.logger.error e.backtrace.join("\n")
      error = e.parse_error
    end

    return result, error
  end
end