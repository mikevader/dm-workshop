class Action < ActiveRecord::Base
  enum action_type: [:action, :reaction, :legendary]

  belongs_to :monster
  
  validates :monster_id, presence: true
  validates :title, presence: true
  validates :action_type, presence: true, inclusion: {in: action_types.keys}
  validates :description, presence: true

  def text
    if melee? and ranged?
      "<i>Melee or Ranged Weapon Attack:</i> #{description}"
    elsif melee?
      "<i>Melee Weapon Attack:</i> #{description}"
    elsif ranged?
      "<i>Ranged Weapon Attack:</i> #{description}"
    else
      description
    end
  end
end
