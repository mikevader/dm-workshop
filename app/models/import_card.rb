class ImportCard
  attr_reader :id
  attr_accessor :import
  attr_accessor :name
  attr_accessor :type
  attr_reader :attributes
  attr_reader :errors
  alias_method :import?, :import

  def initialize(id = -1)
    @id = id
    @import = false
    @attributes = OpenStruct.new
    @errors = []
  end
end