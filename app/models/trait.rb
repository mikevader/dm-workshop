class Trait < ApplicationRecord
  belongs_to :monster, foreign_key: :card_id
  acts_as_list scope: :card

  validates :title, presence: true
  validates :description, presence: true
end
