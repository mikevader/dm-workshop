class Trait < ApplicationRecord
  belongs_to :monster, foreign_key: :card_id

  validates :card_id, presence: true
  validates :title, presence: true
  validates :description, presence: true
end
