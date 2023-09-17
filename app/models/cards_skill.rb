class CardsSkill < ApplicationRecord
    belongs_to :card, optional: true
    belongs_to :skill, optional: true
end
