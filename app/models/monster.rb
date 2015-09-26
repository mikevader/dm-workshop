class Monster < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :skills
  #accepts_nested_attributes_for :skills, reject_if: proc { |skill|
  #  skill['name'].blank?
  #  }, allow_destroy: true
  
  default_scope -> { order(name: :asc) }
  
  #scope :with_saving_throw, lambda { |saving_throw| {:conditions => "saving_throws_mask & #{2**ABILITIES.index(saving_throw.to_s)} > 0"} }
  
  validates :user_id, presence: true
  validates :name, presence: true
  validates :bonus, presence: true
  validates :size, presence: true
  validates :monster_type, presence: true
  validates :armor_class, presence: true
  validates :hit_points, presence: true
  validates :strength, presence: true, numericality: { only_integer: true, greater_than: 0, less_than: 100}
  validates :dexterity, presence: true, numericality: { only_integer: true, greater_than: 0, less_than: 100}
  validates :constitution, presence: true, numericality: { only_integer: true, greater_than: 0, less_than: 100}
  validates :intelligence, presence: true, numericality: { only_integer: true, greater_than: 0, less_than: 100}
  validates :wisdom, presence: true, numericality: { only_integer: true, greater_than: 0, less_than: 100}
  validates :charisma, presence: true, numericality: { only_integer: true, greater_than: 0, less_than: 100}
  
  ABILITIES = %w[str dex con int wis cha]
  
  def saving_throws=(saving_throws)
    self.saving_throws_mask = (saving_throws & ABILITIES).map { |r| 2**ABILITIES.index(r) }.sum
  end
  
  def saving_throws
    ABILITIES.reject { |r| ((self.saving_throws_mask || 0) & 2**ABILITIES.index(r)).zero? }
  end
  
  def saving_throws_symbols
    saving_throws.map(&:to_sym)
  end
  
  def self.search(search)
    if search
      builder = new_builder
      search = Parser.new.parse(search, builder)
      
      query = self
      builder.joins.each do |join|
        query = query.joins(join)
      end
      query = query.where(search)
      builder.orders.each do |order|
        query = query.order(order)
      end
      query.distinct
    else
      all
    end
  end
  
  def strength_modifier
    calc_modifier_for strength
  end

  def dexterity_modifier
    calc_modifier_for dexterity
  end

  def constitution_modifier
    calc_modifier_for constitution
  end

  def intelligence_modifier
    calc_modifier_for intelligence
  end

  def wisdom_modifier
    calc_modifier_for wisdom
  end

  def charisma_modifier
    calc_modifier_for charisma
  end

  
  private
  def self.new_builder
    builder = SearchBuilder.new
    builder.add_field 'name', 'monsters.name'
    builder.add_field 'str', 'monsters.strength'
    builder.add_field 'dex', 'monsters.dexterity'
    builder.add_field 'con', 'monsters.constitution'
    builder.add_field 'int', 'monsters.intelligence'
    builder.add_field 'wis', 'monsters.wisdom'
    builder.add_field 'cha', 'monsters.charisma'
  end
  
  def calc_modifier_for ability = 10
    return (ability - 10) / 2
  end
end
