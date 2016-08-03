class Skill < ApplicationRecord
  has_many :cards_skills, foreign_key: :skill_id
  has_many :skills, through: :cards_skills
  
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
  validates :ability, presence: true
end
