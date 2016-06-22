class MoveSpellsToCards < ActiveRecord::Migration
  def up

    create_join_table :hero_classes, :cards, force: :cascade do |t|
      t.index :hero_class_id
      t.index :card_id
      t.index [:hero_class_id, :card_id], unique: true
    end

    change_table :cards do |t|
      t.integer  "level"
      t.string   "school"
      t.string   "casting_time"
      t.string   "range"
      t.string   "components"
      t.string   "duration"
      t.text     "short_description"
      t.string   "picture"
      t.string   "athigherlevel"
      t.boolean  "concentration"
      t.boolean  "ritual",            default: false
    end

    # set all existing spells to be shared. At the moment only the official spells are published.
    Card.reset_column_information
    HeroClass.reset_column_information

    spells = select_all('SELECT * FROM spells')
    spells.each do |spell|
      spell_id = spell['id']
      type = 'Spell'
      name = spell['name']
      level = spell['level']
      school = spell['school']
      casting_time = spell['casting_time']
      range = spell['range']
      components = spell['components']
      duration = spell['duration']
      short_description = spell['short_description']
      description = spell['description']
      user_id = spell['user_id']
      created_at = spell['created_at']
      updated_at = spell['updated_at']
      picture = spell['picture']
      athigherlevel = spell['athigherlevel']
      concentration = spell['concentration']
      ritual = spell['ritual']
      cite = spell['cite']
      shared = spell['shared']

      card_id = insert("INSERT INTO cards (type, name, level, school, casting_time, range, components, duration, short_description, description, user_id, created_at, updated_at, picture, athigherlevel, concentration, ritual, cite, shared)
        VALUES ('#{type}', #{sani(name)}, #{level}, #{sani(school)}, #{sani(casting_time)}, #{sani(range)}, #{sani(components)}, #{sani(duration)}, #{sani(short_description)}, #{sani(description)}, #{user_id}, '#{created_at}', '#{updated_at}', #{sani(picture)}, #{sani(athigherlevel)}, '#{concentration}', '#{ritual}', #{sani(cite)}, '#{shared}')")

      hero_classes = select_all("SELECT * FROM hero_classes_spells WHERE spell_id = #{spell_id}")
      hero_classes.each do |hc|
        hc_spell_id = hc['spell_id']
        hero_class_id = hc['hero_class_id']

        insert("INSERT INTO cards_hero_classes (card_id, hero_class_id)
          VALUES (#{card_id}, #{hero_class_id})")
      end
    end

    drop_join_table :hero_classes, :spells
    drop_table :spells
  end

  def sani(value)
    return Card.sanitize(value)
  end

  def down
    create_table :spells, force: :cascade do |t|
      t.string   :name
      t.integer  :level
      t.string   :school
      t.string   :casting_time
      t.string   :range
      t.string   :components
      t.string   :duration
      t.text     :short_description
      t.text     :description
      t.datetime :created_at,                        null: false
      t.datetime :updated_at,                        null: false
      t.string   :picture
      t.string   :athigherlevel
      t.boolean  :concentration
      t.boolean  :ritual,            default: false
      t.string   :cite
      t.boolean  :shared,            default: false, null: false
      t.references :user, index: true, foreign_key: true
    end
    create_join_table :hero_classes, :spells, force: :cascade do |t|
      t.index :hero_class_id
      t.index :spell_id
      t.index [:hero_class_id, :spell_id], unique: true
    end

    spells = select_all("SELECT * FROM cards WHERE type LIKE 'spell'")
    spells.each do |spell|
      card_id = spell['id']
      name = spell['name']
      level = spell['level']
      school = spell['school']
      casting_time = spell['casting_time']
      range = spell['range']
      components = spell['components']
      duration = spell['duration']
      short_description = spell['short_description']
      description = spell['description']
      user_id = spell['user_id']
      created_at = spell['created_at']
      updated_at = spell['updated_at']
      picture = spell['picture']
      athigherlevel = spell['athigherlevel']
      concentration = spell['concentration']
      ritual = spell['ritual']
      cite = spell['cite']
      shared = spell['shared']

      spell_id = insert("INSERT INTO spells (name, level, school, casting_time, range, components, duration, short_description, description, user_id, created_at, updated_at, picture, athigherlevel, concentration, ritual, cite, shared)
        VALUES (#{sani(name)}, #{level}, #{sani(school)}, #{sani(casting_time)}, #{sani(range)}, #{sani(components)}, #{sani(duration)}, #{sani(short_description)}, #{sani(description)}, #{user_id}, '#{created_at}', '#{updated_at}', #{sani(picture)}, #{sani(athigherlevel)}, '#{concentration}', '#{ritual}', #{sani(cite)}, '#{shared}')")

      hero_classes = select_all("SELECT * FROM cards_hero_classes WHERE card_id = #{card_id}")
      hero_classes.each do |hc|
        hc_card_id = hc['card_id']
        hero_class_id = hc['hero_class_id']

        insert("INSERT INTO hero_classes_spells (spell_id, hero_class_id)
          VALUES (#{spell_id}, #{hero_class_id})")
      end

      delete("DELETE FROM cards WHERE id = #{card_id}")
    end

    change_table :cards do |t|
      t.remove "level", "school", "casting_time", "range", "components", "duration", "short_description", "picture", "athigherlevel", "concentration", "ritual"
    end

    drop_join_table  :hero_classes, :cards
  end
end
