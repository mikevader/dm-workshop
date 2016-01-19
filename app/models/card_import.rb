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

  attr_writer :current_step

  attr_accessor :monsters_file
  attr_accessor :spells_file
  attr_accessor :items_file
  attr_accessor :references_file
  attr_accessor :imports


  def initialize(user, attributes = {})
    @user = user
    attributes.each { |name, value| send("#{name}=", value) }
    @imports = []
    @spells = []
  end

  def persisted?
    false
  end

  def current_step
    @current_step || steps.first
  end

  def steps
    %w[import select]
  end

  def next_step
    self.current_step = steps[steps.index(current_step) + 1]
  end

  def last_step?
    current_step == steps.last
  end

  def new_record?
    @spells.empty? || @spells.map {|spell| spell.new_record?}.any?
  end

  def save
    @spells = imports.select{|import_card| import_card.import?}.map {|import_card| create_card(@user, import_card)}
    if @spells.map(&:valid?).all?
      @spells.each(&:save!)
      true
    else
      @spells.each_with_index do |spell, index|
        spell.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+1}: #{message}"
        end
      end
      return false
    end

    return true

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

  def import_spells
    imported_spells.each do |spell|
      imports << spell
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
      name = CardImport.load_element '', spell, 'name', true, "inscribe spell: %{value}"

      id = -1
      if existing_spell = Spell.find_by_name(name)
        logger.info "Card %{name} already inscribed"
        id = existing_spell.id
      end
      type = CardImport.load_element name, spell, 'type', true
      level, school = CardImport.parse_school_and_level type
      logger.debug "    level: #{level}"
      logger.debug "    school: #{school}"

      classes = CardImport.load_element name, spell, 'classes' do |node, name|
        node.xpath('class').map { |node| node.text }
      end

      casting_time = CardImport.load_element(name, spell, 'castingtime', true)
      components = CardImport.load_element(name, spell, 'components', false)
      range = CardImport.load_element(name, spell, 'range', false)
      duration = CardImport.load_element(name, spell, 'duration', false)
      concentration = (duration || '').downcase.include? 'concentration'
      logger.debug "    concentration: #{concentration}"
      athigherlevel = CardImport.load_element(name, spell, 'athigherlevel')
      short_description = CardImport.load_element(name, spell, 'shortdescription')
      description = CardImport.load_element(name, spell, 'description')

      import_card = ImportCard.new id
      import_card.import = true if id < 0
      import_card.type = :spell
      import_card.name = %r{^([a-zA-Z'’/\- ]*)( \(Ritual\))?.*$}.match(name)[1]

      import_card.attributes.ritual = name.downcase.include? 'ritual'
      import_card.attributes.level = level
      import_card.attributes.school = school
      import_card.attributes.description = description
      import_card.attributes.classes = classes
      import_card.attributes.casting_time = casting_time
      import_card.attributes.components = components
      import_card.attributes.range = range
      import_card.attributes.duration = duration
      import_card.attributes.concentration = concentration
      import_card.attributes.short_description = short_description
      import_card.attributes.athigherlevel = athigherlevel
      import_card.attributes.description = description
      import_card
    end
  end

  def create_card(user, import_card)
    case import_card.type
      when :spell
        create_spell(user, import_card)
    end
  end

  def create_spell(user, import_card)

    if import_card.id > 0
      new_spell = Spell.find(import_card.id)
      new_spell.name = import_card.name
      new_spell.level = import_card.attributes.level
      new_spell.school = import_card.attributes.school
      new_spell.description = import_card.attributes.description
    else
      new_spell = user.spells.create(
          name: import_card.name,
          level: import_card.attributes.level,
          school: import_card.attributes.school,
          description: import_card.attributes.description)
    end

    hero_classes = import_card.attributes.classes.map do |hero_class|
      HeroClass.find_by(name: hero_class)
    end
    new_spell.hero_classes << hero_classes
    new_spell.ritual = import_card.attributes.ritual
    new_spell.casting_time = import_card.attributes.casting_time
    new_spell.components = import_card.attributes.components
    new_spell.range = import_card.attributes.range
    new_spell.duration = import_card.attributes.duration
    new_spell.concentration = import_card.attributes.concentration
    new_spell.short_description = import_card.attributes.short_description
    new_spell.athigherlevel = import_card.attributes.athigherlevel
    new_spell.description = import_card.attributes.description
    new_spell
  end

  def imported_items
    @imported_items ||= load_imported_items
  end

  def load_imported_items
    items_doc = open_xmlfile(items_file)
    items_doc.xpath('//cards/items/item').map do |item|
      name = CardImport.load_element '', item, 'name', true, "craft item: %{value}"

      if existing_item = Item.find_by_name(name)
        logger.info "Card %{name} already exists."
        next existing_item
      end

      cite = CardImport.load_element(name, item, 'cite', true)
      category = Category.where("lower(name) LIKE ?", CardImport.load_element(name, item, 'type', true).downcase)
      rarity = Rarity.where("lower(name) LIKE ?", CardImport.load_element(name, item, 'rarity', true).downcase)
      attunement = CardImport.load_element(name, item, 'requiresAttunement', false) || 'false'
      description = CardImport.load_element(name, item, 'description', false)


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
      name = CardImport.load_element '', monster, 'name', true, "bread monster: %{value}"

      if existing_monster = Monster.find_by_name(name)
        logger.info "skip because %{name} already bread"
        next existing_monster
      end

      type = CardImport.load_element name,  monster, 'type', true
      cite = CardImport.load_element name, monster, 'cite', false
      description = CardImport.load_element name, monster, 'description', false

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
        proficiency = CardImport.load_element name, stat, 'proficiency', true
        size = CardImport.load_element name, stat, 'size', true
        ac = CardImport.load_element name, stat, 'ac', true
        hp = CardImport.load_element name, stat, 'hp', true
        speed = CardImport.load_element name, stat, 'speed', true
        strength = CardImport.load_element name, stat, 'abilities/@str', true
        dexterity = CardImport.load_element name, stat, 'abilities/@dex', true
        constitution = CardImport.load_element name, stat, 'abilities/@con', true
        intelligence = CardImport.load_element name, stat, 'abilities/@int', true
        wisdom = CardImport.load_element name, stat, 'abilities/@wis', true
        charisma = CardImport.load_element name, stat, 'abilities/@cha', true
        languages = CardImport.load_element name, stat, 'languages', false
        cr = CardImport.load_element name, stat, 'cr', false

        savingThrows = CardImport.load_element name, stat, 'savingThrows/@*' do |node, name|
          node.map { |ability| ability.name }
        end

        skills = CardImport.load_element name, stat, 'skills' do |node, name|
          node.xpath('skill/@name').map { |node| node.text }
        end
        dmgResistance = CardImport.load_element name, stat, 'dmgResistance/*' do |node, name|
          node.map { |dmg| dmg.name }
        end
        dmgImmunity = CardImport.load_element name, stat, 'dmgImmunity/*' do |node, name|
          node.map { |dmg| dmg.name }
        end
        condImmunity = CardImport.load_element name, stat, 'condImmunity/*' do |node, name|
          node.map { |cond| cond.name }
        end
        senses = CardImport.load_element name, stat, 'senses/*' do |node, name|
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
      new_monster.skills << skills.map {|skill| Skill.where("lower(name) LIKE '#{skill.downcase}'")} unless skills.nil?
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

  def self.load_element(for_card, node, name, required = false, description = "    %{name}: %{value}")
    name.downcase!
    value_node = node.xpath(name)
    if value_node.empty?
      raise RuntimeError, "element #{name} is required for #{for_card}." if required
      return nil
    end

    if block_given?
      value = yield value_node, name
    else
      value = node.xpath(name).children.to_s.strip
    end

    if value.empty?
      raise RuntimeError, "element #{name} is required for #{for_card}." if required
      value = nil
    end

    #logger.debug description % {name: name, value: value}
    return value
  end

  def self.parse_school_and_level type_string
    match = /((?<school>\w*) cantrip|(?<level>\d*)[a-z]{0,2}-level (?<school_with_level>\w*))/.match(type_string)
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