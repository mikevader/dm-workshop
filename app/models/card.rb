class Card < ActiveRecord::Base
  acts_as_taggable
  serialize :badges
  belongs_to :user

  default_scope -> { order(name: :asc) }

  validates :user_id, presence: true
  validates :name, presence: true, length: {maximum: 50}, uniqueness: {case_sensitive: false}
  validates :icon, presence: true
  validates :color, presence: true

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

    self.tag_list.each do |tag|
      replica.tag_list.add(tag)
    end

    replica
  end

  def card_data
    data = CardData.new

    data.id = id
    data.name = name
    data.icon = icon
    data.color = color

    unless contents.nil?
      contents.lines.map(&:strip).each do |line|
        parts = line.split('|').map(&:strip)

        element_name = parts.first
        element_params = parts.drop(1)

        case element_name
          when 'subtitle'
            data.add_subtitle(element_params)
          when 'rule'
            data.add_rule
          when 'property'
            data.add_property element_params
          when 'description'
            data.add_description element_params
          when 'text'
            data.add_text element_params
          when 'boxes'
            data.add_boxes element_params
          when 'fill'
            data.add_fill element_params
          when 'subsection'
            data.add_subsection element_params
          when 'bullet'
            data.add_bullet element_params
          else
            data.add_unknown element_name
        end
      end
    end

    return data
  end

  def self.new_search_builder
    builder = SearchBuilder.new do
      configure_field 'name', 'cards.name'
      configure_tag 'tags', Card
    end
    return builder
  end
end
