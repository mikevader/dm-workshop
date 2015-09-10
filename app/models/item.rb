class Item < ActiveRecord::Base
  belongs_to :category
  belongs_to :rarity
  belongs_to :user
  has_many :properties, dependent: :destroy
  accepts_nested_attributes_for :properties, reject_if: proc { |attributes| attributes['name'].blank? }, allow_destroy: true
  
  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
  validates :category_id, presence: true
  validates :rarity_id, presence: true
    
end
