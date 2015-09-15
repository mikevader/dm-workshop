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
      builder.orders.each do |join|
        query = query.order(join)
      end
      query.distinct
    else
      all
    end
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
