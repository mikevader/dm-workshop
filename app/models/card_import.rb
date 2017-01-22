module StringToBoolean
  def to_b
    return true if self == true || self =~ (/^(true|t|yes|y|1)$/i)
    return false if self == false || self.blank? || self =~ (/^(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end
class String;
  include StringToBoolean;
end

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
  attr_accessor :cards_file
  attr_accessor :imports


  def initialize(user, attributes = {})
    @user = user
    attributes.each { |name, value| send("#{name}=", value) }
    @imports = []
    @cards = []
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
    @cards.empty? || @cards.map { |card| card.new_record? }.any?
  end

  def save
    @cards = imports.select { |import_card| import_card.import? }.map { |import_card| create_new_card(@user, import_card) }
    if @cards.map(&:valid?).all?
      @cards.each(&:save!)
      true
    else
      @cards.each_with_index do |card, index|
        card.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+1}: #{message}"
        end
      end
      return false
    end
  end

  def import_files
    import_monsters unless monsters_file.nil?
    import_spells unless spells_file.nil?
    import_items unless items_file.nil?
    import_cards unless cards_file.nil?
  end

  def import_monsters
    imported_monsters.each do |monster|
      imports << monster
    end
  end

  def import_items
    imported_items.each do |item|
      imports << item
    end
  end

  def import_cards
    imported_cards.each do |item|
      imports << item
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


  def load_common_attributes(name, card, attributes)
    source_name = CardImport.load_element(name, card, 'source', false)
    if (source_name)
      source = Source.where('lower(name) LIKE ?', source_name.downcase)
    else
      source = Source.first
    end
    card_size = CardImport.load_element(name, card, 'cardSize', false) || '25x35'
    cite = CardImport.load_element name, card, 'cite', false
    shared = CardImport.load_element(name, card, 'shared', false) || 'false'

    attributes.source = source
    attributes.card_size = card_size
    attributes.cite = cite
    attributes.shared = shared.to_b
  end

  def create_cards_common_attributes(attributes, card)
    card.source = attributes.source
    card.card_size = attributes.card_size
    card.cite = attributes.cite
    card.shared = attributes.shared

  end

  def load_imported_spells
    spells_doc = open_xmlfile(spells_file)

    spells_doc.xpath('//cards/spells/spell').map do |spell|
      complete_name = CardImport.load_element '', spell, 'name', true, 'inscribe card: %{value}'
      name = %r{^([a-zA-Z'’/\- ]*)( \(Ritual\))?.*$}.match(complete_name)[1].squish
      ritual = complete_name.downcase.include? 'ritual'
      unless (existing_spell = Spell.find_by_name(name)).nil?
        logger.info "Spell #{name} already inscribed"
        id = existing_spell.id
      end

      type = CardImport.load_element name, spell, 'type', true
      level, school = CardImport.parse_school_and_level type
      logger.debug "    level: #{level}"
      logger.debug "    school: #{school}"

      classes = CardImport.load_element name, spell, 'classes' do |node, _class_name|
        node.xpath('class').map(&:text)
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

      import_card = ImportCard.new(id, :spell)
      import_card.name = name
      load_common_attributes(name, spell, import_card.attributes)

      import_card.attributes.ritual = ritual
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

  def create_new_card(user, import_card)
    case import_card.type
      when :spell
        create_spell(user, import_card)
      when :monster
        create_monster(user, import_card)
      when :item
        create_item(user, import_card)
      when :card
        create_card(user, import_card)
    end
  end

  def create_spell(user, import_card)
    if import_card.new_record?
      new_spell = user.spells.create(
          name: import_card.name,
          level: import_card.attributes.level,
          school: import_card.attributes.school,
          description: import_card.attributes.description)
    else
      new_spell = Spell.find(import_card.id)
      new_spell.hero_classes.delete_all
      new_spell.name = import_card.name
      new_spell.level = import_card.attributes.level
      new_spell.school = import_card.attributes.school
      new_spell.description = import_card.attributes.description
    end

    create_cards_common_attributes(import_card.attributes, new_spell)
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
      name = CardImport.load_element '', item, 'name', true, 'craft item: %{value}'

      unless (existing_item = Item.find_by_name(name)).nil?
        logger.info "Item #{name} already exists."
        id = existing_item.id
      end

      category = Category.where('lower(name) LIKE ?', CardImport.load_element(name, item, 'type', true).downcase)
      rarity = Rarity.where('lower(name) LIKE ?', CardImport.load_element(name, item, 'rarity', true).downcase)
      attunement = CardImport.load_element(name, item, 'requiresAttunement', false) || 'false'
      description = CardImport.load_element(name, item, 'description', false)

      import_card = ImportCard.new(id, :item)
      import_card.name = name
      load_common_attributes(name, item, import_card.attributes)

      import_card.attributes.category = category.take!
      import_card.attributes.rarity = rarity.take!
      import_card.attributes.attunement = attunement.to_b
      import_card.attributes.description = description
      import_card
    end
  end

  def create_item(user, import_card)
    if import_card.new_record?
      new_item = user.items.create(name: import_card.name)
    else
      new_item = Item.find(import_card.id)
      new_item.name = import_card.name
    end

    create_cards_common_attributes(import_card.attributes, new_item)
    new_item.category = import_card.attributes.category
    new_item.rarity = import_card.attributes.rarity
    new_item.attunement = import_card.attributes.attunement
    new_item.description = import_card.attributes.description
    new_item
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
      name = CardImport.load_element '', monster, 'name', true, 'bread monster: %{value}'

      unless (existing_monster = Monster.find_by_name(name)).nil?
        logger.info "Monster #{name} already bread"
        id = existing_monster.id
      end

      card_size = CardImport.load_element(name, monster, 'cardSize', false) || '35x50'
      type = CardImport.load_element name, monster, 'type', true
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

      saving_throws = []
      skills = []
      dmg_vulnerability = []
      dmg_resistance = []
      dmg_immunity = []
      cond_immunity = []
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
        cr = Rational(%r{([0-9\/]+)( \([\d']+ XP\))?}.match(cr)[1]).to_f

        saving_throws = CardImport.load_element name, stat, 'savingThrows/@*' do |node, _name|
          node.map(&:name)
        end

        skills = CardImport.load_element name, stat, 'skills' do |node, _name|
          node.xpath('skill/@name').map(&:text)
        end
        dmg_vulnerability = CardImport.load_element name, stat, 'dmgVulnerability/*' do |node, _name|
          node.map(&:name)
        end
        dmg_resistance = CardImport.load_element name, stat, 'dmgResistance/*' do |node, _name|
          node.map(&:name)
        end
        dmg_immunity = CardImport.load_element name, stat, 'dmgImmunity/*' do |node, _name|
          node.map(&:name)
        end
        cond_immunity = CardImport.load_element name, stat, 'condImmunity/*' do |node, _name|
          node.map(&:name)
        end
        senses = CardImport.load_element name, stat, 'senses/*' do |node, _name|
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

      import_card = ImportCard.new(id, :monster)
      import_card.name = name
      load_common_attributes(name, monster, import_card.attributes)

      import_card.attributes.card_size = card_size
      import_card.attributes.bonus = proficiency
      import_card.attributes.monster_size = size
      import_card.attributes.monster_type = type
      import_card.attributes.armor_class = ac
      import_card.attributes.hit_points = hp
      import_card.attributes.speed = speed
      import_card.attributes.strength = strength
      import_card.attributes.dexterity = dexterity
      import_card.attributes.constitution = constitution
      import_card.attributes.intelligence = intelligence
      import_card.attributes.wisdom = wisdom
      import_card.attributes.charisma = charisma
      import_card.attributes.languages = languages
      import_card.attributes.challenge = cr

      import_card.attributes.saving_throws = saving_throws
      import_card.attributes.skills = skills
      import_card.attributes.senses = senses.join(', ') unless senses.nil?

      import_card.attributes.damage_vulnerabilities = dmg_vulnerability
      import_card.attributes.damage_resistances = dmg_resistance
      import_card.attributes.damage_immunities = dmg_immunity
      import_card.attributes.cond_immunities = cond_immunity

      import_card.attributes.description = description
      import_card.attributes.traits = traits
      import_card.attributes.actions = actions

      import_card
    end
  end

  def create_monster(user, import_card)
    if import_card.new_record?
      new_monster = user.monsters.create(name: import_card.name)
    else
      new_monster = Monster.find(import_card.id)
      new_monster.skills.delete_all
      new_monster.traits.delete_all
      new_monster.actions.delete_all
      new_monster.name = import_card.name
    end

    create_cards_common_attributes(import_card.attributes, new_monster)
    new_monster.monster_size = import_card.attributes.monster_size
    new_monster.monster_type = import_card.attributes.monster_type
    new_monster.armor_class = import_card.attributes.armor_class
    new_monster.hit_points = import_card.attributes.hit_points
    new_monster.speed = import_card.attributes.speed
    new_monster.strength = import_card.attributes.strength
    new_monster.dexterity = import_card.attributes.dexterity
    new_monster.constitution = import_card.attributes.constitution
    new_monster.intelligence = import_card.attributes.intelligence
    new_monster.wisdom = import_card.attributes.wisdom
    new_monster.charisma = import_card.attributes.charisma
    new_monster.languages = import_card.attributes.languages
    new_monster.challenge = import_card.attributes.challenge

    new_monster.saving_throws = import_card.attributes.saving_throws unless import_card.attributes.saving_throws.nil?
    new_monster.skills << import_card.attributes.skills.map { |skill| Skill.where('lower(name) LIKE ?', skill.downcase) } unless import_card.attributes.skills.nil?
    new_monster.senses = import_card.attributes.senses

    new_monster.damage_vulnerabilities = import_card.attributes.damage_vulnerabilities unless import_card.attributes.damage_vulnerabilities.nil?
    new_monster.damage_resistances = import_card.attributes.damage_resistances unless import_card.attributes.damage_resistances.nil?
    new_monster.damage_immunities = import_card.attributes.damage_immunities unless import_card.attributes.damage_immunities.nil?
    new_monster.cond_immunities = import_card.attributes.cond_immunities unless import_card.attributes.cond_immunities.nil?

    new_monster.description = import_card.attributes.description
    new_monster.save!

    import_card.attributes.traits.each do |trait|
      new_monster.traits.create title: trait.title, description: trait.description
    end

    import_card.attributes.actions.each do |action|
      new_monster.actions.create title: action.title, description: action.description
    end

    new_monster
  end

  def imported_cards
    @imported_card ||= load_imported_cards
  end

  def load_imported_cards
    cards_doc = open_xmlfile(cards_file)
    cards_doc.xpath('//cards/cards/card').map do |card|
      name = CardImport.load_element '', card, 'name', true, 'craft card: %{value}'

      unless (existing_card = Card.find_by_name(name)).nil?
        logger.info "Card #{name} already printed"
        id = existing_card.id
      end

      color = CardImport.load_element name, card, 'color', false
      icon = CardImport.load_element name, card, 'icon', false
      badges = CardImport.load_element name, card, 'badges', false
      contents = CardImport.load_element name, card, 'contents', false

      import_card = ImportCard.new(id, :card)
      import_card.name = name
      load_common_attributes(name, card, import_card.attributes)

      import_card.attributes.color = color
      import_card.attributes.icon = icon
      import_card.attributes.badges = badges
      import_card.attributes.contents = contents
      import_card
    end
  end

  def create_card(user, import_card)
    if import_card.new_record?
      card = user.free_forms.create(name: import_card.name)
    else
      card = Card.find(import_card.id)
      card.name = import_card.name
    end

    create_cards_common_attributes(import_card.attributes, card)
    card.color = import_card.attributes.color
    card.icon = import_card.attributes.icon
    card.badges = import_card.attributes.badges
    card.contents = import_card.attributes.contents

    card
  end

  def open_xmlfile(file)
    case File.extname(file.original_filename)
      when '.xml' then
        item_file = File.open(file.path)
        Nokogiri::Slop(item_file)
      else
        raise "Unknown file type: #{file.original_filename}"
    end
  end

  private

  def self.load_element(for_card, node, name, required = false, _description = '    %{name}: %{value}')
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
