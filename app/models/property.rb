class Property < ActiveRecord::Base
  belongs_to :item
  
  validates :name, presence: true
end
