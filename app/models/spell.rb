class Spell < ActiveRecord::Base
  acts_as_taggable
  belongs_to :user
  has_and_belongs_to_many :hero_classes

  default_scope -> { order(name: :asc) }
  mount_uploader :picture, PictureUploader

  validates :user_id, presence: true
  validates :name, presence: true
  validates :level, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 9}
  validates :school, presence: true
  # validate :spell_unique_per_class
  validate :picture_size

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

  def self.new_search_builder
    builder = SearchBuilder.new do
      configure_field 'name', 'spells.name'
      configure_field 'ritual', 'spells.ritual'
      configure_field 'school', 'spells.school'
      configure_field 'level', 'spells.level'
      configure_field 'concentration', 'spells.concentration'
      configure_field 'duration', 'spells.duration'
      configure_field 'castingTime', 'spells.casting_time'
      configure_tag 'tags', Spell
      configure_relation 'classes', 'hero_classes.name', :hero_classes
    end
    return builder
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
    if hero_classes.select { |c| hero_classes.select { |q| q == c }.size > 1 }.any?
      errors.add :spell, 'tried to add a class multiple times'
    end
  end

end
