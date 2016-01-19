class ImportCard
  attr_reader :id
  attr_accessor :import
  attr_accessor :name
  attr_accessor :type
  attr_reader :attributes
  attr_reader :errors
  alias_method :import?, :import

  def initialize(id = -1, type)
    @id = (id.nil?) ? -1 : id
    @type = type
    @import = (@id < 0) ? true : false
    @attributes = OpenStruct.new
    @errors = []
  end

  def new_record?
    @id < 0
  end
end