class Skill < ActiveRecord::Base
  has_and_belongs_to_many :monsters
  
  validates :name, presence: true
  validates :ability, presence: true
end
