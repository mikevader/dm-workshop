class Filter < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
end
