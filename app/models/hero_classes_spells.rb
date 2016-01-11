class HeroClassesSpells < ActiveRecord::Base
  belongs_to :spell, class_name: "Spell"
  belongs_to :hero_class, class_name: "HeroClass"

  validates :spell_id, presence: true
  validates :hero_class_id, presence: true
end
