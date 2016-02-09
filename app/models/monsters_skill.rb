class MonstersSkill < ActiveRecord::Base
    belongs_to :monster
    belongs_to :skill
end