class Source < ApplicationRecord
  has_many :cards

  validates :name, presence: true, length: {maximum: 50}, uniqueness: {case_sensitive: false}
end
