# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
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


spell_file = File.open("cards/spells.xml")
spell_doc = Nokogiri::Slop(spell_file)

puts "new spells"
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


item_file = File.open("cards/items.xml")
item_doc = Nokogiri::Slop(item_file)

puts "new items"
item_doc.xpath('//cards/items/item').each do |spell|
  name = load_element spell, 'name', true, "craft item: %{value}"
  cite = load_element(spell, 'cite', true)
  category = Category.where("name LIKE ?", load_element(spell, 'type', true))
  rarity = Rarity.where("name LIKE ?", load_element(spell, 'rarity', true))
  attunement = load_element(spell, 'requiresAttunement', false) | false
  description = load_element(spell, 'description', false)
  
  
  new_item = default.items.create(name: name)
  new_item.category = category.take!
  new_item.rarity = rarity.take!
  new_item.attunement = attunement
  new_item.description = description
  new_item.save
end

