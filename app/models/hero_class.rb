class HeroClass < ActiveRecord::Base
  has_and_belongs_to_many :spells, join_table: :cards_hero_classes, foreign_key: :hero_class_id, association_foreign_key: :card_id

  default_scope -> { order(name: :asc) }

  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
  validates :cssclass, presence: true, length: { maximum: 50 }
end
