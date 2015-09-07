class Item < ActiveRecord::Base
  belongs_to :category
  belongs_to :rarity
  belongs_to :user
end
