class Monster < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :skills
  has_many :traits
  has_many :actions
  
  accepts_nested_attributes_for :actions, reject_if: proc { |action| action['title'].blank? }, allow_destroy: true
  accepts_nested_attributes_for :traits, reject_if: proc { |action| action['title'].blank? }, allow_destroy: true

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
  
  # str   1
  # dex   2
  # con   4
  # int   8
  # wis  16
  # cha  32
  ABILITIES = %w[str dex con int wis cha]
  
  # acid =        1
  # bludgeoning   2
  # cold          4
  # fire          8
  # force        16
  # lightning    32
  # necrotic     64
  # piercing    128
  # poison      256
  # psychic     512
  # radiant    1024
  # slashing   2048
  # thunder    4096
  DAMAGE_TYPES = %w[acid bludgeoning cold fire force lightning necrotic piercing poison psychic radiant slashing thunder]
  
  # exhaustion        1
  # blinded           2
  # charmed           4
  # deafened          8
  # frightened       16
  # grappled         32
  # incapacitated    64
  # invisible       128
  # paralyzed       256
  # petrified       512
  # poisonded      1024
  # prone          2048
  # restrained     4096
  # stunned        8192
  # unconscious   16384
  CONDITIONS = %w[exhaustion blinded charmed deafened frightened grappled incapacitated invisible paralyzed petrified poisoned prone restrained stunned unconscious]
  
  def saving_throws=(saving_throws)
    self.saving_throws_mask = (saving_throws & ABILITIES).map { |r| 2**ABILITIES.index(r) }.sum
  end
  def saving_throws
    ABILITIES.reject { |r| ((self.saving_throws_mask || 0) & 2**ABILITIES.index(r)).zero? }
  end

  def damage_vulnerabilities=(damage_vulnerabilities)
    self.damage_vulnerabilities_mask = (damage_vulnerabilities & DAMAGE_TYPES).map { |r| 2**DAMAGE_TYPES.index(r) }.sum
  end
  def damage_vulnerabilities
    DAMAGE_TYPES.reject { |r| ((self.damage_vulnerabilities_mask || 0) & 2**DAMAGE_TYPES.index(r)).zero? }
  end

  def damage_resistances=(damage_resistances)
    self.damage_resistances_mask = (damage_resistances & DAMAGE_TYPES).map { |r| 2**DAMAGE_TYPES.index(r) }.sum
  end
  def damage_resistances
    DAMAGE_TYPES.reject { |r| ((self.damage_resistances_mask || 0) & 2**DAMAGE_TYPES.index(r)).zero? }
  end

  def damage_immunities=(damage_immunities)
    self.damage_immunities_mask = (damage_immunities & DAMAGE_TYPES).map { |r| 2**DAMAGE_TYPES.index(r) }.sum
  end
  def damage_immunities
    DAMAGE_TYPES.reject { |r| ((self.damage_immunities_mask || 0) & 2**DAMAGE_TYPES.index(r)).zero? }
  end

  def cond_immunities=(cond_immunities)
    self.cond_immunities_mask = (cond_immunities & CONDITIONS).map { |r| 2**CONDITIONS.index(r) }.sum
  end
  def cond_immunities
    CONDITIONS.reject { |r| ((self.cond_immunities_mask || 0) & 2**CONDITIONS.index(r)).zero? }
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

  CR_XP = [100, 200, 450, 700, 1100, 1800, 2300, 2900, 3900, 5000, 5900, 7200, 8400, 10000, 11500, 13000, 15000, 18000, 20000, 22000, 25000, 33000, 41000, 50000, 62000, 75000, 90000, 105000, 120000, 135000, 155000]
  def self.print_challenge_rating cr
    xp = CR_XP[cr].to_s.gsub(/(\d)(?=\d{3}+(?:\.|$))(\d{3}\..*)?/,'\1\'\2')
    "#{cr} (#{xp} XP)"
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
