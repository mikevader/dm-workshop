# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

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
  name = load_element spell, 'name', true, "inscribe spell: %{value}"
  type = load_element spell, 'type', true
  level, school = parse_school_and_level type
  puts "    level: #{level}"
  puts "    school: #{school}"

  classes = load_element spell, 'classes' do |node, name|
    node.xpath('class').map { |node| node.text }.join(', ')
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

