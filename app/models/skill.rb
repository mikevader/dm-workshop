class Skill < ActiveRecord::Base
  has_and_belongs_to_many :monsters
  
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
  validates :ability, presence: true
end
