# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).


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
barbarian   = HeroClass.create!(name: "Barbarian",  cssclass: "icon-class-barbarian")
bard        = HeroClass.create!(name: "Bard",       cssclass: "icon-class-bard")
cleric      = HeroClass.create!(name: "Cleric",     cssclass: "icon-class-cleric")
druid       = HeroClass.create!(name: "Druid",      cssclass: "icon-class-druid")
figher      = HeroClass.create!(name: "Figher",     cssclass: "icon-class-figher")
monk        = HeroClass.create!(name: "Monk",       cssclass: "icon-class-monk")
paladin     = HeroClass.create!(name: "Paladin",    cssclass: "icon-class-paladin")
ranger      = HeroClass.create!(name: "Ranger",     cssclass: "icon-class-ranger")
rogue       = HeroClass.create!(name: "Rogue",      cssclass: "icon-class-rogue")
sorcerer    = HeroClass.create!(name: "Sorcerer",   cssclass: "icon-class-sorcerer")
warlock     = HeroClass.create!(name: "Warlock",    cssclass: "icon-class-warlock")
wizard      = HeroClass.create!(name: "Wizard",     cssclass: "icon-class-wizard")

# Categories
armor         = Category.create!(name: 'Armor',         cssclass: 'icon-custom-armor-heavy')
poison        = Category.create!(name: 'Poison',        cssclass: 'icon-custom-poison')
potion        = Category.create!(name: 'Potion',        cssclass: 'icon-custom-potion')
ring          = Category.create!(name: 'Ring',          cssclass: 'icon-custom-ring')
scroll        = Category.create!(name: 'Scroll',        cssclass: 'icon-custom-scroll')
staff         = Category.create!(name: 'Staff',         cssclass: 'icon-custom-staff')
wand          = Category.create!(name: 'Wand',          cssclass: 'icon-custom-wand')
weapon        = Category.create!(name: 'Weapon',        cssclass: 'icon-custom-swordarrow')
wondrous_item = Category.create!(name: 'Wondrous item', cssclass: 'icon-custom-item')

# Rarities
common    = Rarity.create!(name: 'Common')
uncommon  = Rarity.create!(name: 'Uncommon')
rare      = Rarity.create!(name: 'Rare')
very_rare = Rarity.create!(name: 'Very rare')
legendary = Rarity.create!(name: 'Legendary')


if User.find_by_email('michael@anduin.ch').nil?
  User.create!(name:  "Michael Mühlebach",
             email: "michael@anduin.ch",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)
end

