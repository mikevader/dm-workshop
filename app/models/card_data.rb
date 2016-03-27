class CardData
  attr_accessor :id
  attr_accessor :name
  attr_accessor :icon
  attr_accessor :color
  attr_accessor :card_size
  attr_accessor :badges
  attr_accessor :description

  def initialize
    @id = -1
    @contents = []
    @badges = []
    @card_size = '25x35'
    @description = ''
  end

  def contents
    @contents
  end

  def add_subtitle params
    @contents << CardElement.new(:subtitle, params.first)
  end

  def add_rule
    @contents << CardElement.new(:rule)
  end

  def add_property params
    @contents << CardElement.new(:property, params.first, params.second)
  end

  def add_description params
    @contents << CardElement.new(:description, params.first, params.second)
  end

  def add_text params
    @contents << CardElement.new(:text, params.first)
  end

  def add_subsection params
    @contents << CardElement.new(:subsection, params.first)
  end

  def add_boxes params
    @contents << CardElement.new(:boxes, params.first, params.second)
  end

  def add_fill params
    @contents << CardElement.new(:fill, params.first)
  end

  def add_bullet(params)
    @contents << CardElement.new(:bullet, params.first)
  end

  def add_dndstats(params)
    @contents << CardElement.new(:dndstats, params.first, params.second, params.third, params.fourth, params.fifth, params[5])
  end

  def add_unknown(element_name)
    @contents << CardElement.new(:unknown, element_name)
  end

  class CardElement
    attr_accessor :subtitle
    alias_method :subtitle?, :subtitle
    attr_accessor :rule
    alias_method :rule?, :rule
    attr_accessor :property
    alias_method :property?, :property
    attr_accessor :description
    alias_method :description?, :description
    attr_accessor :text
    alias_method :text?, :text
    attr_accessor :subsection
    alias_method :subsection?, :subsection
    attr_accessor :boxes
    alias_method :boxes?, :boxes
    attr_accessor :fill
    alias_method :fill?, :fill
    attr_accessor :bullet
    alias_method :bullet?, :bullet
    attr_accessor :dndstats
    alias_method :dndstats?, :dndstats
    attr_accessor :unknown
    alias_method :unknown?, :unknown

    def initialize(type, *args)
      send("#{type}=", true)

      @args = args
      @type = type
    end

    def type
      @type
    end

    def args
      @args
    end
    def params
      @args
    end
  end
end

