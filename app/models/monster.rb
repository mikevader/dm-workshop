class Monster < ActiveRecord::Base
  acts_as_taggable
  belongs_to :user
  has_many :monsters_skills, -> { order(skill_id: :asc) }
  has_many :skills, through: :monsters_skills
  has_many :traits, dependent: :destroy
  has_many :actions, dependent: :destroy

  accepts_nested_attributes_for :actions, reject_if: proc { |action| action['title'].blank? }, allow_destroy: true
  accepts_nested_attributes_for :traits, reject_if: proc { |trait| trait['title'].blank? }, allow_destroy: true
  accepts_nested_attributes_for :monsters_skills, reject_if: proc { |monsters_skill| monsters_skill['skill_id'].blank? }, allow_destroy: true

  default_scope -> { order(name: :asc) }

  validates :user_id, presence: true
  validates :name, presence: true, length: {maximum: 50}, uniqueness: {case_sensitive: false}
  validates :challenge, presence: true, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 50}
  validates :size, presence: true
  validates :monster_type, presence: true
  validates :armor_class, presence: true
  validates :hit_points, presence: true
  validates :strength, presence: true, numericality: {only_integer: true, greater_than: 0, less_than: 100}
  validates :dexterity, presence: true, numericality: {only_integer: true, greater_than: 0, less_than: 100}
  validates :constitution, presence: true, numericality: {only_integer: true, greater_than: 0, less_than: 100}
  validates :intelligence, presence: true, numericality: {only_integer: true, greater_than: 0, less_than: 100}
  validates :wisdom, presence: true, numericality: {only_integer: true, greater_than: 0, less_than: 100}
  validates :charisma, presence: true, numericality: {only_integer: true, greater_than: 0, less_than: 100}

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

    self.tag_list.each do |tag|
      replica.tag_list.add(tag)
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
      0 => {xp: 0, bonus: 2},
      0.125 => {xp: 25, bonus: 2},
      0.25 => {xp: 50, bonus: 2},
      0.5 => {xp: 100, bonus: 2},
      1 => {xp: 200, bonus: 2},
      2 => {xp: 450, bonus: 2},
      3 => {xp: 700, bonus: 2},
      4 => {xp: 1100, bonus: 2},
      5 => {xp: 1800, bonus: 3},
      6 => {xp: 2300, bonus: 3},
      7 => {xp: 2900, bonus: 3},
      8 => {xp: 3900, bonus: 3},
      9 => {xp: 5000, bonus: 4},
      10 => {xp: 5900, bonus: 4},
      11 => {xp: 7200, bonus: 4},
      12 => {xp: 8400, bonus: 4},
      13 => {xp: 10000, bonus: 5},
      14 => {xp: 11500, bonus: 5},
      15 => {xp: 13000, bonus: 5},
      16 => {xp: 15000, bonus: 5},
      17 => {xp: 18000, bonus: 6},
      18 => {xp: 20000, bonus: 6},
      19 => {xp: 22000, bonus: 6},
      20 => {xp: 25000, bonus: 6},
      21 => {xp: 33000, bonus: 7},
      22 => {xp: 41000, bonus: 7},
      23 => {xp: 50000, bonus: 7},
      24 => {xp: 62000, bonus: 7},
      25 => {xp: 75000, bonus: 8},
      26 => {xp: 90000, bonus: 8},
      27 => {xp: 105000, bonus: 8},
      28 => {xp: 120000, bonus: 8},
      29 => {xp: 135000, bonus: 9},
      30 => {xp: 155000, bonus: 9}}

  def self.cr_xp
    return CR_XP.map { |key, value| [key, value[:xp]] }.to_h
  end

  def self.cr_xp_bonus
    return CR_XP
  end

  def self.xp_for_cr cr
    cr = cr.to_i if cr.denominator == 1
    return cr_xp[cr].to_s.gsub(/(\d)(?=\d{3}+(?:\.|$))(\d{3}\..*)?/, '\1\'\2')
  end

  def self.challenge_pretty cr
    return '' if cr.nil?
    return cr.to_r.to_s unless cr.denominator == 1
    return cr.to_i.to_s
  end

  def bonus
    cr = challenge.nil? ? 0 : challenge
    cr = cr.to_i if cr.denominator == 1
    CR_XP[cr][:bonus]
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
      data.add_property ['Saving throws', saving_throws.map { |saving_throw| "#{saving_throw.titleize} #{'%+d' % saving_throw_modifier(saving_throw)}" }.join(', ')]
    end

    unless monsters_skills.empty?
      data.add_property ['Skills', monsters_skills.map { |monsters_skill| "#{monsters_skill.skill.name} #{'%+d' % skill_modifier(monsters_skill)}" }.join(', ')]
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

    actions_action = actions.select(&:action?)
    actions_reaction = actions.select(&:reaction?)
    actions_legendary = actions.select(&:legendary?)

    data.add_subsection ['Action'] unless actions_action.empty?
    actions_action.each do |action|
      data.add_description [action.title, action.text]
    end

    data.add_subsection ['Reaction'] unless actions_reaction.empty?
    actions_reaction.each do |action|
      data.add_description [action.title, action.text]
    end

    data.add_subsection ['Legendary Action'] unless actions_legendary.empty?
    actions_legendary.each do |action|
      data.add_description [action.title, action.text]
    end

    return data
  end

  def self.new_search_builder
    builder = SearchBuilder.new do
      configure_field 'name', 'monsters.name'
      configure_field 'str', 'monsters.strength'
      configure_field 'dex', 'monsters.dexterity'
      configure_field 'con', 'monsters.constitution'
      configure_field 'int', 'monsters.intelligence'
      configure_field 'wis', 'monsters.wisdom'
      configure_field 'cha', 'monsters.charisma'
      configure_tag 'tags', Monster
    end
    return builder
  end

  private

  def calc_modifier_for ability = 10
    return (ability - 10) / 2
  end

  def skill_modifier(monsters_skill)
    raise ArgumentError if monsters_skill.nil?

    return monsters_skill.value unless monsters_skill.value.nil?

    skill = monsters_skill.skill
    modifier = ability_modifier(skill.ability)
    modifier += bonus

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
      else
        # type code here
    end
  end
end
