class CardsSkill < ActiveRecord::Base
    belongs_to :card
    belongs_to :skill
end