class Property < ApplicationRecord
  belongs_to :item, foreign_key: :card_id
  acts_as_list scope: :card

  validates :name, presence: true
end
