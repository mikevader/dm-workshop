class Rarity < ActiveRecord::Base
  has_many :items

  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
end
