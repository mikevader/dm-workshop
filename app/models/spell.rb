class Spell < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order(name: :asc) }

  validates :user_id, presence: true
  validates :name, presence: true
  validates :school, presence: true
  validates :level, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 9}
end
