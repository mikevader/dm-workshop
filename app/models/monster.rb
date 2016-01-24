class Monster < ActiveRecord::Base
  acts_as_taggable
  belongs_to :user
  has_and_belongs_to_many :skills
  has_many :traits, dependent: :destroy
  has_many :actions, dependent: :destroy

  accepts_nested_attributes_for :actions, reject_if: proc { |action| action['title'].blank? }, allow_destroy: true
  accepts_nested_attributes_for :traits, reject_if: proc { |action| action['title'].blank? }, allow_destroy: true

  #accepts_nested_attributes_for :skills, reject_if: proc { |skill|
  #  skill['name'].blank?
  #  }, allow_destroy: true

  default_scope -> { order(name: :asc) }

  #scope :with_saving_throw, lambda { |saving_throw| {:conditions => "saving_throws_mask & #{2**ABILITIES.index(saving_throw.to_s)} > 0"} }

  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
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

  def replicate
    replica = dup

    skills.each do |skill|
      replica.skills << skill
    end

    traits.each do |trait|
      replica.traits << trait.dup
    end

    actions.each do |action|
      replica.actions << action.dup
    end

    replica
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

  CR_XP = {
      0 => 0,
      0.125 => 25,
      0.25 => 50,
      0.5 => 100,
      1 => 200,
      2 => 450,
      3 => 700,
      4 => 1100,
      5 => 1800,
      6 => 2300,
      7 => 2900,
      8 => 3900,
      9 => 5000,
      10 => 5900,
      11 => 7200,
      12 => 8400,
      13 => 10000,
      14 => 11500,
      15 => 13000,
      16 => 15000,
      17 => 18000,
      18 => 20000,
      19 => 22000,
      20 => 25000,
      21 => 33000,
      22 => 41000,
      23 => 50000,
      24 => 62000,
      25 => 75000,
      26 => 90000,
      27 => 105000,
      28 => 120000,
      29 => 135000,
      30 => 155000}
  def self.xp_for_cr cr
    cr = cr.to_i if cr.denominator == 1
    return CR_XP[cr].to_s.gsub(/(\d)(?=\d{3}+(?:\.|$))(\d{3}\..*)?/,'\1\'\2')
  end

  def self.challenge_pretty cr
    return '' if cr.nil?
    return cr.to_r.to_s unless cr.denominator == 1
    return cr.to_i.to_s
  end

  def card_data
    data = CardData.new

    data.id = id
    data.name = name
    data.icon = 'icon-custom-monster'
    data.color = 'black'
    data.card_size = '35x50'

    data.add_subtitle ["#{size.try(:capitalize)} #{monster_type}, #{alignment}"]

    data.add_rule
    data.add_property ['Armor Class', armor_class]
    data.add_property ['Hit Points', hit_points]
    data.add_property ['Speed', speed]
    data.add_rule
    data.add_dndstats [strength, dexterity, constitution, intelligence, wisdom, charisma]
    data.add_rule

    unless saving_throws.empty?
      data.add_property ['Saving throws', saving_throws.map {|saving_throw| "#{saving_throw.titleize} #{'%+d' % saving_throw_modifier(saving_throw)}"}.join(', ')]
    end

    unless skills.empty?
      data.add_property ['Skills', skills.map {|skill| "#{skill.name} #{'%+d' % skill_modifier(skill)}"}.join(', ')]
    end

    unless damage_vulnerabilities.blank?
      data.add_property ['Damage Vulnerabilities', damage_vulnerabilities.join(', ')]
    end
    unless damage_resistances.blank?
      data.add_property ['Damage Resistance', damage_resistances.join(', ')]
    end
    unless damage_immunities.blank?
      data.add_property ['Damage Immunities', damage_immunities.join(', ')]
    end
    unless cond_immunities.blank?
      data.add_property ['Condition Immunities', cond_immunities.join(', ')]
    end

    data.add_property ['Senses', senses] unless senses.blank?
    data.add_property ['Languages', languages] unless languages.blank?
    data.add_property ['Challenge', "#{Monster.challenge_pretty(challenge)} (#{Monster.xp_for_cr(challenge)} XP)"] unless challenge.blank?

    data.add_rule

    traits.each do |trait|
      data.add_description [trait.title, trait.description]
    end

    data.add_fill [2]

    data.add_subsection ['Action'] unless actions.empty?
    actions.each do |action|
      data.add_description [action.title, action.description]
    end

    return data
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
    return builder
  end

  def calc_modifier_for ability = 10
    return (ability - 10) / 2
  end

  def skill_modifier(skill)
    raise ArgumentError if skill.nil?

    modifier = ability_modifier(skill.ability)

    modifier += bonus if skills.include? skill

    return modifier
  end

  def saving_throw_modifier(saving_throw)
    modifier = ability_modifier(saving_throw)

    modifier += bonus if saving_throws.include? saving_throw

    return modifier
  end

  def ability_modifier(ability)
    case ability.downcase
      when 'str'
        strength_modifier
      when 'dex'
        dexterity_modifier
      when 'con'
        constitution_modifier
      when 'int'
        intelligence_modifier
      when 'wis'
        wisdom_modifier
      when 'cha'
        charisma_modifier
    end
  end
end
