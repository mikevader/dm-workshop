module StringToBoolean
  def to_b
    return true if self == true || self =~ (/^(true|t|yes|y|1)$/i)
    return false if self == false || self.blank? || self =~ (/^(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end
class String; include StringToBoolean; end

class CardImport

  # switch to ActiveModel::Model in Rails 4
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :monsters_file
  attr_accessor :spells_file
  attr_accessor :items_file
  attr_accessor :references_file

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end

  def save(user)
    @user = user
    unless spells_file.nil?
      if imported_spells.map(&:valid?).all?
        imported_spells.each(&:save!)
        true
      else
        imported_spells.each_with_index do |spell, index|
          spell.errors.full_messages.each do |message|
            errors.add :base, "Row #{index+1}: #{message}"
          end
        end
        return false
      end
    end

    unless items_file.nil?
      if imported_items.map(&:valid?).all?
        imported_items.each(&:save!)
        true
      else
        imported_items.each_with_index do |item, index|
          item.errors.full_messages.each do |message|
            errors.add :base, "Row #{index+1}: #{message}"
          end
        end
        return false
      end
    end

    unless monsters_file.nil?
      if imported_monsters.map(&:valid?).all?
        imported_monsters.each(&:save!)
        true
      else
        imported_monsters.each_with_index do |monster, index|
          monster.errors.full_messages.each do |message|
            errors.add :base, "Row #{index+1}: #{message}"
          end
        end
        return false
      end
    end
  end


  private
  def logger
    Rails.logger
  end

  def imported_spells
    @imported_spells ||= load_imported_spells
  end

  def load_imported_spells
    spells_doc = open_xmlfile(spells_file)

    spells_doc.xpath('//cards/spells/spell').map do |spell|
      name = CardImport.load_element spell, 'name', true, "inscribe spell: %{value}"

      if existing_spell = Spell.find_by_name(name)
        logger.info "skip because %{name} already inscribed"
        next existing_spell
      end
      type = CardImport.load_element spell, 'type', true
      level, school = CardImport.parse_school_and_level type
      logger.debug "    level: #{level}"
      logger.debug "    school: #{school}"

      classes = CardImport.load_element spell, 'classes' do |node, name|
        node.xpath('class').map { |node| node.text }.join(', ')
      end
      hero_classes = CardImport.load_element spell, 'classes' do |node, name|
        node.xpath('class').map { |node| HeroClass.find_by(name: node.text) }.to_a
      end
      casting_time = CardImport.load_element(spell, 'castingtime', true)
      components = CardImport.load_element(spell, 'components', true)
      range = CardImport.load_element(spell, 'range', true)
      duration = CardImport.load_element(spell, 'duration', true)
      concentration = duration.downcase.include? 'concentration'
      logger.debug "    concentration: #{concentration}"
      athigherlevel = CardImport.load_element(spell, 'athigherlevel')
      short_description = CardImport.load_element(spell, 'shortdescription')
      description = CardImport.load_element(spell, 'description')

      new_spell = @user.spells.create(name: name, level: level, school: school, description: description)
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
      new_spell
    end
  end

  def imported_items
    @imported_items ||= load_imported_items
  end

  def load_imported_items
    items_doc = open_xmlfile(items_file)
    items_doc.xpath('//cards/items/item').map do |item|
      name = CardImport.load_element item, 'name', true, "craft item: %{value}"

      if existing_item = Item.find_by_name(name)
        logger.info "skip because %{name} already crafted"
        next existing_item
      end

      cite = CardImport.load_element(item, 'cite', true)
      category = Category.where("name LIKE ?", CardImport.load_element(item, 'type', true))
      rarity = Rarity.where("name LIKE ?", CardImport.load_element(item, 'rarity', true))
      attunement = CardImport.load_element(item, 'requiresAttunement', false) || 'false'
      description = CardImport.load_element(item, 'description', false)


      new_item = @user.items.create(name: name)
      new_item.category = category.take!
      new_item.rarity = rarity.take!
      new_item.attunement = attunement.to_b
      new_item.description = description
      new_item.cite = cite
      new_item
    end
  end

  def imported_monsters
    @imported_monsters ||= load_imported_monsters
  end

  def load_imported_monsters
    monsters_doc = open_xmlfile(monsters_file)
    prepared_traits = {}
    monsters_doc.xpath('//traits/trait[not(ancestor::monster)]').each do |trait|
      prepared_traits[trait.attributes['id'].value] = OpenStruct.new(title: trait.attributes['name'].value, description: trait.children.to_s.squish)
    end

    monsters_doc.xpath('//cards/monsters/monster').map do |monster|
      name = CardImport.load_element monster, 'name', true, "bread monster: %{value}"

      if existing_monster = Monster.find_by_name(name)
        logger.info "skip because %{name} already bread"
        next existing_monster
      end

      type = CardImport.load_element monster, 'type', true
      cite = CardImport.load_element monster, 'cite', false
      description = CardImport.load_element monster, 'description', false

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
        proficiency = CardImport.load_element stat, 'proficiency', true
        size = CardImport.load_element stat, 'size', true
        ac = CardImport.load_element stat, 'ac', true
        hp = CardImport.load_element stat, 'hp', true
        speed = CardImport.load_element stat, 'speed', true
        strength = CardImport.load_element stat, 'abilities/@str', true
        dexterity = CardImport.load_element stat, 'abilities/@dex', true
        constitution = CardImport.load_element stat, 'abilities/@con', true
        intelligence = CardImport.load_element stat, 'abilities/@int', true
        wisdom = CardImport.load_element stat, 'abilities/@wis', true
        charisma = CardImport.load_element stat, 'abilities/@cha', true
        languages = CardImport.load_element stat, 'languages', false
        cr = CardImport.load_element stat, 'cr', false

        savingThrows = CardImport.load_element stat, 'savingThrows/@*' do |node, name|
          node.map { |ability| ability.name }
        end

        skills = CardImport.load_element stat, 'skills' do |node, name|
          node.xpath('skill/@name').map { |node| node.text }
        end
        dmgResistance = CardImport.load_element stat, 'dmgResistance/*' do |node, name|
          node.map { |dmg| dmg.name }
        end
        dmgImmunity = CardImport.load_element stat, 'dmgImmunity/*' do |node, name|
          node.map { |dmg| dmg.name }
        end
        condImmunity = CardImport.load_element stat, 'condImmunity/*' do |node, name|
          node.map { |cond| cond.name }
        end
        senses = CardImport.load_element stat, 'senses/*' do |node, name|
          node.map { |sense| "#{sense.xpath('@name')}: #{sense.text}" }
        end
      end

      traits = monster.xpath('traits/*').map do |node|
        unless node.attributes['id'].blank?
          prepared_traits[node.attributes['id'].value]
        else
          OpenStruct.new(title: node.attributes['name'].value, description: node.children.to_s.squish)
        end
      end
      logger.debug "    traits: #{traits}"

      actions = monster.xpath('actions/*').map do |node|
        test = ''
        if node.name == 'meleeweaponattack'
          test = '<i>Melee Weapon Attack:</i> '
        elsif node.name == 'rangedweaponattack'
          test = '<i>Ranged Weapon Attack:</i> '
        end
        OpenStruct.new(title: node.attributes['name'].value, description: "#{test}#{node.children.to_s.squish}")
      end
      logger.debug "    actions: #{actions}"

      new_monster = @user.monsters.create(name: name)
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
      new_monster
    end
  end

  def open_xmlfile(file)
    case File.extname(file.original_filename)
      when ".xml" then
        item_file = File.open(file.path)
        Nokogiri::Slop(item_file)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def self.load_element(node, name, required = false, description = "    %{name}: %{value}")
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

    #logger.debug description % {name: name, value: value}
    return value
  end

  def self.parse_school_and_level type_string
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
end