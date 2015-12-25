class HeroClass < ActiveRecord::Base
  has_many :spellclasses, class_name: "Spellclass", foreign_key: "hero_class_id", dependent: :destroy
  has_many :spells, through: :spellclasses, source: :spell
  
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
  validates :cssclass, presence: true, length: { maximum: 50 }
end
