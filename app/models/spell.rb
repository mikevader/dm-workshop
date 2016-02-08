class Spell < ActiveRecord::Base
  acts_as_taggable
  belongs_to :user
  has_and_belongs_to_many :hero_classes

  default_scope -> { order(name: :asc) }
  mount_uploader :picture, PictureUploader

  validates :user_id, presence: true
  validates :name, presence: true
  validates :level, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 9}
  validates :school, presence: true
  # validate :spell_unique_per_class
  validate :picture_size
  
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

    hero_classes.each do |hero_class|
      replica.hero_classes << hero_class
    end

    replica
  end

  def card_data
    data = CardData.new

    data.id = id
    data.name = "#{name}#{' (Ritual)' if ritual?}"
    data.icon = "icon-white-book-#{level}"
    data.color = 'maroon'

    hero_classes.each do |hero_class|
      data.badges << hero_class.cssclass
    end

    if level == 0
      data.add_subtitle ["#{school} cantrip"]
    else
      data.add_subtitle ["#{level.try(:ordinalize)}-level #{school}"]
    end

    data.add_rule
    data.add_property ['Casting Time', casting_time]
    data.add_property ['Range', range]
    data.add_property ['Components', components]
    data.add_property ['Duration', duration]
    data.add_fill [2]

    if short_description.blank?
      data.add_text [description]
    else
      data.add_text [short_description]
    end

    unless athigherlevel.blank?
      data.add_subsection ['At higher levels']
      data.add_text [athigherlevel]
    end

    data
  end
  
  private
  # Validates the size of an uploaded picture.
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end

  # Validates the uniqueness of a spell in a class
  def spell_unique_per_class
    if hero_classes.select {|c| hero_classes.select {|q| q == c }.size > 1 }.any?
      errors.add :spell, 'tried to add a class multiple times'
    end
  end
  
  def self.new_builder
    builder = SearchBuilder.new
    builder.configure_field 'name', 'spells.name'
    builder.configure_field 'ritual', 'spells.ritual'
    builder.configure_field 'school', 'spells.school'
    builder.configure_field 'level', 'spells.level'
    builder.configure_field 'concentration', 'spells.concentration'
    builder.configure_field 'duration', 'spells.duration'
    builder.configure_field 'castingTime', 'spells.casting_time'
    builder.configure_tag 'tags', Spell
    builder.configure_relation 'classes', 'hero_classes.name', :hero_classes
    return builder
  end
end
