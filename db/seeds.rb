# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).


module StringToBoolean
  def to_b
    return true if self == true || self =~ (/^(true|t|yes|y|1)$/i)
    return false if self == false || self.blank? || self =~ (/^(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end
class String; include StringToBoolean; end


# Skills
acrobatics      = Skill.create!(name: "Acrobatics",       ability: "Dex")
animal_handling = Skill.create!(name: "Animal Handling",  ability: "Wis")
arcana          = Skill.create!(name: "Arcana",           ability: "Int")
athletics       = Skill.create!(name: "Athletics",        ability: "Str")
deception       = Skill.create!(name: "Deception",        ability: "Cha")
history         = Skill.create!(name: "History",          ability: "Int")
insight         = Skill.create!(name: "Insight",          ability: "Wis")
intimidation    = Skill.create!(name: "Intimidation",     ability: "Cha")
investigation   = Skill.create!(name: "Investigation",    ability: "Int")
medicine        = Skill.create!(name: "Medicine",         ability: "Wis")
nature          = Skill.create!(name: "Nature",           ability: "Int")
perception      = Skill.create!(name: "Perception",       ability: "Wis")
performance     = Skill.create!(name: "Performance",      ability: "Cha")
persuasion      = Skill.create!(name: "Persuasion",       ability: "Cha")
religion        = Skill.create!(name: "Religion",         ability: "Int")
sleight_of_hand = Skill.create!(name: "Sleight of Hand",  ability: "Dex")
stealth         = Skill.create!(name: "Stealth",          ability: "Dex")
survival        = Skill.create!(name: "Survival",         ability: "Wis")



# Hero classes
barbarian = HeroClass.create!(name: "Barbarian", cssclass: "icon-class-barbarian")
bard = HeroClass.create!(name: "Bard", cssclass: "icon-class-bard")
cleric = HeroClass.create!(name: "Cleric", cssclass: "icon-class-cleric")
druid = HeroClass.create!(name: "Druid", cssclass: "icon-class-druid")
figher = HeroClass.create!(name: "Figher", cssclass: "icon-class-figher")
monk = HeroClass.create!(name: "Monk", cssclass: "icon-class-monk")
paladin = HeroClass.create!(name: "Paladin", cssclass: "icon-class-paladin")
ranger = HeroClass.create!(name: "Ranger", cssclass: "icon-class-ranger")
rogue = HeroClass.create!(name: "Rogue", cssclass: "icon-class-rogue")
sorcerer = HeroClass.create!(name: "Sorcerer", cssclass: "icon-class-sorcerer")
warlock = HeroClass.create!(name: "Warlock", cssclass: "icon-class-warlock")
wizard = HeroClass.create!(name: "Wizard", cssclass: "icon-class-wizard")

# Categories
armor = Category.create!(name: 'Armor', cssclass: 'icon-custom-armor-heavy')
potion = Category.create!(name: 'Potion', cssclass: 'icon-custom-potion')
ring = Category.create!(name: 'Ring', cssclass: 'icon-custom-ring')
scroll = Category.create!(name: 'Scroll', cssclass: 'icon-custom-scroll')
staff = Category.create!(name: 'Staff', cssclass: 'icon-custom-staff')
wand = Category.create!(name: 'Wand', cssclass: 'icon-custom-wand')
weapon = Category.create!(name: 'Weapon', cssclass: 'icon-custom-swordarrow')
wondrous_item = Category.create!(name: 'Wondrous item', cssclass: 'icon-custom-item')

# Rarities
common = Rarity.create!(name: 'Common')
uncommon = Rarity.create!(name: 'Uncommon')
rare = Rarity.create!(name: 'Rare')
very_rare = Rarity.create!(name: 'Very rare')
legendary = Rarity.create!(name: 'Legendary')


default = User.create!(name:  "Michael Mühlebach",
             email: "michael@anduin.ch",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)


default.items.create!(name: "Armor +1", category_id: armor.id, rarity_id: rare.id, description: "You have a bonus of +1 to AC while wearing this armor.")




def load_element(node, name, required = false, description = "    %{name}: %{value}")
  name.downcase!
  value_node = node.xpath(name)
  if value_node.empty?
    raise RuntimeError, "element #{name} is required." if required
    return nil
  end
  
  if block_given?
    value = yield value_node, name
  else
    value = node.xpath(name).children.to_s.strip
  end

  if value.empty?
    raise RuntimeError, "element #{name} is required." if required
    value = nil
  end

  puts description % {name: name, value: value}
  return value
end

def parse_school_and_level type_string
    match = /((?<school>\w*) cantrip|(?<level>\d*)[a-z]{2}-level (?<school_with_level>\w*))/.match(type_string)
  if match[:level].nil?
    level = 0
    school = match[:school]
  else
    level = match[:level]
    school = match[:school_with_level]
  end

  return level, school
end


# Import spells.xml
puts "new spells"
spell_file = File.open("cards/spells.xml")
spell_doc = Nokogiri::Slop(spell_file)

spell_doc.xpath('//cards/spells/spell').each do |spell|
  name = load_element spell, 'name', true, "inscribe spell: %{value}"
  type = load_element spell, 'type', true
  level, school = parse_school_and_level type
  puts "    level: #{level}"
  puts "    school: #{school}"

  classes = load_element spell, 'classes' do |node, name|
    node.xpath('class').map { |node| node.text }.join(', ')
  end
  hero_classes = load_element spell, 'classes' do |node, name|
    node.xpath('class').map { |node| HeroClass.find_by(name: node.text) }.to_a
  end
  casting_time = load_element(spell, 'castingtime', true)
  components = load_element(spell, 'components', true)
  range = load_element(spell, 'range', true)
  duration = load_element(spell, 'duration', true)
  concentration = duration.downcase.include? 'concentration'
  puts "    concentration: #{concentration}"
  athigherlevel = load_element(spell, 'athigherlevel')
  short_description = load_element(spell, 'shortdescription')
  description = load_element(spell, 'description')
  
  new_spell = default.spells.create!(name: name, level: level, school: school, description: description)
  new_spell.classes = classes
  new_spell.hero_classes << hero_classes
  new_spell.casting_time = casting_time
  new_spell.components = components
  new_spell.range = range
  new_spell.duration = duration
  new_spell.concentration = concentration
  new_spell.short_description = short_description
  new_spell.athigherlevel = athigherlevel
  new_spell.description = description
  new_spell.save
end

# Import items.xml
puts "new items"

item_file = File.open("cards/items.xml")
item_doc = Nokogiri::Slop(item_file)
item_doc.xpath('//cards/items/item').each do |item|
  name = load_element item, 'name', true, "craft item: %{value}"
  cite = load_element(item, 'cite', true)
  category = Category.where("name LIKE ?", load_element(item, 'type', true))
  rarity = Rarity.where("name LIKE ?", load_element(item, 'rarity', true))
  attunement = load_element(item, 'requiresAttunement', false) || 'false'
  description = load_element(item, 'description', false)
  
  
  new_item = default.items.create(name: name)
  new_item.category = category.take!
  new_item.rarity = rarity.take!
  new_item.attunement = attunement.to_b
  new_item.description = description
  new_item.cite = cite
  new_item.save
end

# Import monsters.xml
puts "New Monsters"

monster_file = File.open("cards/monsters.xml")
monster_doc = Nokogiri::Slop(monster_file)

prepared_traits = {}
monster_doc.xpath('//traits/trait[not(ancestor::monster)]').each do |trait|
  prepared_traits[trait.attributes['id'].value] = OpenStruct.new(title: trait.attributes['name'].value, description: trait.children.to_s.squish)
end

monster_doc.xpath('//cards/monsters/monster').each do |monster|
  name = load_element monster, 'name', true, "bread monster: %{value}"
  type = load_element monster, 'type', true
  cite = load_element monster, 'cite', false
  description = load_element monster, 'description', false

  proficiency = nil
  size = nil
  ac = nil
  hp = nil
  speed = nil
  strength = nil
  dexterity = nil
  constitution = nil
  intelligence = nil
  wisdom = nil
  charisma = nil
  languages = nil
  cr = nil
  
  savingThrows = []
  skills = []
  dmgResistance = []
  dmgImmunity = []
  condImmunity = []
  senses = []
  
  monster.xpath('stats').each do |stat|
    proficiency = load_element stat, 'proficiency', true
    size = load_element stat, 'size', true
    ac = load_element stat, 'ac', true
    hp = load_element stat, 'hp', true
    speed = load_element stat, 'speed', true
    strength = load_element stat, 'abilities/@str', true
    dexterity = load_element stat, 'abilities/@dex', true
    constitution = load_element stat, 'abilities/@con', true
    intelligence = load_element stat, 'abilities/@int', true
    wisdom = load_element stat, 'abilities/@wis', true
    charisma = load_element stat, 'abilities/@cha', true
    languages = load_element stat, 'languages', false
    cr = load_element stat, 'cr', false
    
    savingThrows = load_element stat, 'savingThrows/@*' do |node, name|
      node.map { |ability| ability.name }
    end

    skills = load_element stat, 'skills' do |node, name|
      node.xpath('skill/@name').map { |node| node.text }
    end
    dmgResistance = load_element stat, 'dmgResistance/*' do |node, name|
      node.map { |dmg| dmg.name }
    end
    dmgImmunity = load_element stat, 'dmgImmunity/*' do |node, name|
      node.map { |dmg| dmg.name }
    end
    condImmunity = load_element stat, 'condImmunity/*' do |node, name|
      node.map { |cond| cond.name }
    end
    senses = load_element stat, 'senses' do |node, name|
      node.xpath('sense/@name').map { |node| node.text }
    end
  end
  
  traits = monster.xpath('traits/*').map do |node|
    unless node.attributes['id'].blank?
      prepared_traits[node.attributes['id'].value]
    else
      OpenStruct.new(title: node.attributes['name'].value, description: node.children.to_s.squish)
    end
  end
  puts "    traits: #{traits}"
  
  actions = monster.xpath('actions/*').map do |node|
    test = ''
    if node.name == 'meleeweaponattack'
      test = 'Melee weapon attack: '
    elsif node.name == 'rangedweaponattack'
      test = 'Ranged weapon attack: '
    end
    OpenStruct.new(title: node.attributes['name'].value, description: "#{test}#{node.children.to_s.squish}")
  end
  puts "    actions: #{actions}"
  
  new_monster = default.monsters.create(name: name)
  new_monster.bonus = proficiency
  new_monster.cite = cite
  new_monster.size = size
  new_monster.monster_type = type
  new_monster.armor_class = ac
  new_monster.hit_points = hp
  new_monster.speed = speed
  new_monster.strength = strength
  new_monster.dexterity = dexterity
  new_monster.constitution = constitution
  new_monster.intelligence = intelligence
  new_monster.wisdom = wisdom
  new_monster.charisma = charisma
  new_monster.languages = languages
  new_monster.challenge = cr
  
  new_monster.saving_throws = savingThrows unless savingThrows.nil?
  new_monster.skills << skills.map {|skill| Skill.where("name LIKE '#{skill.capitalize}'")} unless skills.nil?
  new_monster.senses = senses.join(', ') unless senses.nil?
  
  new_monster.damage_resistances = dmgResistance unless dmgResistance.nil?
  new_monster.damage_immunities = dmgImmunity unless dmgImmunity.nil?
  new_monster.cond_immunities = condImmunity unless condImmunity.nil?
  
  new_monster.description = description
  new_monster.save

  traits.each do |trait|
    new_trait = new_monster.traits.build title: trait.title, description: trait.description
    new_trait.save
  end

  actions.each do |action|
    new_action = new_monster.actions.build title: action.title, description: action.description
    new_action.save
  end

end
