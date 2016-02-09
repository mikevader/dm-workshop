class Skill < ActiveRecord::Base
  has_many :monsters_skills
  has_many :skills, through: :monsters_skills
  
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
  validates :ability, presence: true
end
