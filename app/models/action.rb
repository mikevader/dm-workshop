class Action < ActiveRecord::Base
  belongs_to :monster
  
  validates :monster_id, presence: true
  validates :title, presence: true
  validates :description, presence: true
end
