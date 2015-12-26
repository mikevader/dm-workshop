class Card < ActiveRecord::Base
  belongs_to :user

  default_scope -> { order(name: :asc) }

  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
  validates :icon, presence: true
  validates :color, presence: true

end
