class Property < ApplicationRecord
  belongs_to :item, foreign_key: :card_id
  
  validates :name, presence: true
end
