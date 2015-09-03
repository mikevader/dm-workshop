# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

require 'Nokogiri'

default = User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)



f = File.open("cards/spells.xml")
doc = Nokogiri::Slop(f)

puts "new spells"
doc.xpath('//cards/spells/spell').each do |spell|
  name = spell.xpath('name').text
  puts "inscribe spell: #{name}"
  type = spell.xpath('type').text
  match = /((?<school>\w*) cantrip|(?<level>\d*)[a-z]{2}-level (?<school_with_level>\w*))/.match(type)
  if match[:level].nil?
    level = 0
    school = match[:school]
  else
    level = match[:level]
    school = match[:school_with_level]
  end
  puts "    level: #{level}"
  puts "    school: #{school}"

  classes = spell.classes.xpath('class').map { |node| node.text }.join(', ')
  puts "    classes: #{classes}"
  casting_time = spell.castingtime.text
  puts "    casting_time: #{casting_time}"
  components = spell.components.text
  puts "    components: #{components}"
  range = spell.range.text
  puts "    range: #{range}"
  duration = spell.duration.text
  puts "    duration: #{duration}"
  debugger
  athigherlevel = spell.athigherlevel.text unless spell.athigherlevel.nil?
  puts "    athigherlevel: #{athigherlevel}"
  description = spell.xpath('description').children unless spell.description.nil?
  puts "    description: #{description}"
  short_description = spell.xpath('shortdescription').children unless spell.shortdescription.nil?
  puts "    short_description: #{short_description}"
  new_spell = default.spells.create!(name: name, level: level, school: school, description: description)
  
  new_spell.classes = classes
  new_spell.casting_time = casting_time
  new_spell.components = components
  new_spell.range = range
  new_spell.duration = duration
  new_spell.short_description = short_description
  new_spell.description = description
  new_spell.save
end
