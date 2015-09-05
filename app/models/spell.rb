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
      where('name LIKE ?', "%#{search}%")
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
end
