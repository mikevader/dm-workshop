class Category < ApplicationRecord
  has_many :items

  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
end
