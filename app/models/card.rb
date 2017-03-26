class Card < ApplicationRecord
  acts_as_taggable

  has_and_belongs_to_many :hero_classes, join_table: :cards_hero_classes, foreign_key: :card_id, association_foreign_key: :hero_class_id
  has_and_belongs_to_many :spellbooks, join_table: :spellbooks_spells, foreign_key: :spell_id, association_foreign_key: :spellbook_id
  serialize :badges
  belongs_to :user
  belongs_to :source

  default_scope -> { order(name: :asc) }

  validates :user_id, presence: true
  validates :source_id, presence: true
  validates :card_size, presence: true#, inclusion: { in: Card.card_sizes }
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }

  def self.card_sizes
    %w(25x35 35x50 50x70)
  end

  def width
    case card_size
      when '25x35'
        return 63
      when '35x50'
        return 88
      when '50x70'
        return 126
    end
  end
  def height
    case card_size
      when '25x35'
        return 88
      when '35x50'
        return 126
      when '50x70'
        return 176
    end
  end

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
    data.card_size = card_size
    data.icon = icon unless icon.nil?
    data.color = color unless color.nil?

    return data
  end

  def self.new_search_builder
    builder = SearchBuilder.new do
      # General
      configure_field 'name', 'cards.name'
      configure_field 'type', 'cards.type'
      configure_tag 'tags', Card

      configure_relation 'source', 'sources.name', 'source'

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
      configure_relation 'spellbooks', 'spellbooks.name', :spellbooks

      # Monsters
      configure_field 'cr', 'cards.challenge'
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
