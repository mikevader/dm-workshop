class Spell < ActiveRecord::Base
  belongs_to :user
  has_many :spellclasses, class_name: "Spellclass", foreign_key: "spell_id", dependent: :destroy
  has_many :hero_classes, through: :spellclasses, source: :hero_class
  
  default_scope -> { order(name: :asc) }
  mount_uploader :picture, PictureUploader

  validates :user_id, presence: true
  validates :name, presence: true
  validates :level, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 9}
  validates :school, presence: true
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

  def card_data
    data = CardData.new

    data.id = id
    data.name = name
    data.icon = "icon-white-book-#{level}"
    data.color = 'maroon'

    hero_classes.each do |hero_class|
      data.badges << hero_class.cssclass
    end

    unless level == 0
      data.add_subtitle ["#{level.ordinalize}-level #{school}"]
    else
      data.add_subtitle ["#{school} cantrip"]
    end

    data.add_rule
    data.add_property ['Casting Time', casting_time]
    data.add_property ['Range', range]
    data.add_property ['Components', components]
    data.add_property ['Duration', duration]
    data.add_fill [2]

    unless short_description.blank?
      data.add_text [short_description]
    else
      data.add_text [description]
    end

    unless athigherlevel.blank?
      data.add_subsection ['At higher levels']
      data.add_text [athigherlevel]
    end

    return data
  end
  
  private
  # Validates the size of an uploaded picture.
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end
  
  def self.new_builder
    builder = SearchBuilder.new
    builder.add_field 'name', 'spells.name'
    builder.add_field 'school', 'spells.school'
    builder.add_field 'level', 'spells.level'
    builder.add_field 'concentration', 'spells.concentration'
    builder.add_field 'duration', 'spells.duration'
    builder.add_field 'castingTime', 'spells.casting_time'
    builder.add_relation 'classes', 'hero_classes.name', :hero_classes
    return builder
  end
end
