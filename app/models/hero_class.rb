class HeroClass < ActiveRecord::Base
  has_and_belongs_to_many :spells, -> { distinct }, uniq: true, order: name

  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
  validates :cssclass, presence: true, length: { maximum: 50 }
end
