class Item < ActiveRecord::Base
  belongs_to :category
  belongs_to :rarity
  belongs_to :user
  
  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
  validates :category_id, presence: true
  validates :rarity_id, presence: true
end
