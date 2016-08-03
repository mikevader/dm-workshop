class Card < ApplicationRecord
  acts_as_taggable
  serialize :badges
  belongs_to :user

  default_scope -> { order(name: :asc) }

  validates :user_id, presence: true
  validates :name, presence: true, length: {maximum: 50}, uniqueness: {case_sensitive: false}
  #validates :icon, presence: true
  #validates :color, presence: true

  def self.types
    %w(Item FreeForm Monster Spell)
  end

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
      # General
      configure_field 'name', 'cards.name'
      configure_field 'type', 'cards.type'
      configure_tag 'tags', Card

      # FreeForms
      configure_field 'color', 'cards.color'

      # Items
      configure_field 'attunement', 'cards.attunement'
      configure_relation 'category', 'categories.name', 'category'
      configure_relation 'rarity', 'rarities.name', 'rarity'

      # Spells
      configure_field 'ritual', 'cards.ritual'
      configure_field 'school', 'cards.school'
      configure_field 'level', 'cards.level'
      configure_field 'concentration', 'cards.concentration'
      configure_field 'duration', 'cards.duration'
      configure_field 'castingTime', 'cards.casting_time'
      configure_relation 'classes', 'hero_classes.name', :hero_classes

      # Monsters
      configure_field 'str', 'cards.strength'
      configure_field 'dex', 'cards.dexterity'
      configure_field 'con', 'cards.constitution'
      configure_field 'int', 'cards.intelligence'
      configure_field 'wis', 'cards.wisdom'
      configure_field 'cha', 'cards.charisma'
    end
    return builder
  end
end
