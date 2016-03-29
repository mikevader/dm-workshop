class Item < ActiveRecord::Base
  acts_as_taggable
  belongs_to :category
  belongs_to :rarity
  belongs_to :user
  has_many :properties, dependent: :destroy
  accepts_nested_attributes_for :properties, reject_if: proc { |attributes| attributes['name'].blank? }, allow_destroy: true

  default_scope -> { order(name: :asc) }

  validates :user_id, presence: true
  validates :name, presence: true, length: {maximum: 50}, uniqueness: {case_sensitive: false}
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

  def replicate
    replica = dup

    properties.each do |property|
      replica.properties << property.dup
    end

    self.tag_list.each do |tag|
      replica.tag_list.add(tag)
    end

    replica
  end

  def card_data
    data = CardData.new

    data.id = id
    data.name = name
    data.icon = category.cssclass unless category.nil?
    data.color = 'grey'
    data.description = description

    data.add_subtitle ["#{category.name}, #{rarity.name}"] unless category.nil? or rarity.nil?
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

  def self.new_search_builder
    builder = SearchBuilder.new do
      configure_field 'name', 'items.name'
      configure_field 'attunement', 'items.attunement'
      configure_tag 'tags', Item
      configure_relation 'category', 'categories.name', 'category'
      configure_relation 'rarity', 'rarities.name', 'rarity'
    end
    return builder
  end
end
