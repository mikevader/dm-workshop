class Trait < ActiveRecord::Base
  belongs_to :monster

  validates :title, presence: true
  validates :description, presence: true
end
