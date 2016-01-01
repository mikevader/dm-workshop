class Item < ActiveRecord::Base
  belongs_to :category
  belongs_to :rarity
  belongs_to :user
  has_many :properties, dependent: :destroy
  accepts_nested_attributes_for :properties, reject_if: proc { |attributes| attributes['name'].blank? }, allow_destroy: true
    
  default_scope -> { order(name: :asc) }
  
  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
  validates :category_id, presence: true
  validates :rarity_id, presence: true
    
  def self.search(search)
    if search
      builder = new_builder
      search = Parser.new.parse(search, builder)
      
      query = self
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

  def card_data
    data = CardData.new

    data.id = id
    data.name = name
    data.icon = category.cssclass
    data.color = 'grey'

    data.add_subtitle ["#{category.name}, #{rarity.name}"]
    data.add_rule
    data.add_property ['attunement', attunement.to_s]
    properties.each do |property|
      data.add_property [property.name, property.value]
    end
    data.add_rule
    data.add_fill [2]
    data.add_text [description]
    data.add_fill [3]

    return data
  end

  private
  def self.new_builder
    builder = SearchBuilder.new
    builder.add_field 'name', 'items.name'
    builder.add_field 'attunement', 'items.attunement'
    builder.add_relation 'category', 'categories.name', 'category'
    builder.add_relation 'rarity', 'rarities.name', 'rarity'
    return builder
  end

end
