class MoveMonstersToCards < ActiveRecord::Migration
  def up
    create_table :cards_skills, force: :cascase do |t|
      t.integer :value
      t.timestamps
      t.references :card, index: true, foreign_key: true
      t.references :skill, index: true, foreign_key: true
      t.index [:skill_id, :card_id], unique: true
    end

    change_table :cards do |t|
      t.string   "size"
      t.string   "monster_type"
      t.string   "alignment"
      t.string   "armor_class"
      t.integer  "hit_points"
      t.string   "speed"
      t.integer  "strength"
      t.integer  "dexterity"
      t.integer  "constitution"
      t.integer  "intelligence"
      t.integer  "wisdom"
      t.integer  "charisma"
      t.string   "senses"
      t.string   "languages"
      t.float    "challenge",                   default: 0.0,   null: false
      t.integer  "saving_throws_mask"
      t.integer  "damage_vulnerabilities_mask"
      t.integer  "damage_resistances_mask"
      t.integer  "damage_immunities_mask"
      t.integer  "cond_immunities_mask"
    end
    Card.reset_column_information

    add_reference :traits, :card, index: true, foreign_key: true
    Trait.reset_column_information

    add_reference :actions, :card, index: true, foreign_key: true
    Action.reset_column_information

    monsters = select_all('SELECT * FROM monsters')
    monsters.each do |monster|
      monster_id = monster['id']
      type = 'Monster'
      name = monster['name']
      cite = monster['cite']
      size = monster['size']
      monster_type = monster['monster_type']
      alignment = monster['alignment']
      armor_class = monster['armor_class']
      hit_points = monster['hit_points']
      speed = monster['speed']
      strength = monster['strength']
      dexterity = monster['dexterity']
      constitution = monster['constitution']
      intelligence = monster['intelligence']
      wisdom = monster['wisdom']
      charisma = monster['charisma']
      senses = monster['senses']
      languages = monster['languages']
      challenge = monster['challenge']
      description = monster['description']
      created_at = monster['created_at']
      updated_at = monster['updated_at']
      user_id = monster['user_id']
      saving_throws_mask = monster['saving_throws_mask']
      damage_vulnerabilities_mask = monster['damage_vulnerabilities_mask']
      damage_resistances_mask = monster['damage_resistances_mask']
      damage_immunities_mask = monster['damage_immunities_mask']
      cond_immunities_mask = monster['cond_immunities_mask']
      shared = monster['shared']

      card_id = insert("INSERT INTO cards (type, name, cite, size, monster_type, alignment, armor_class, hit_points, speed, strength, dexterity, constitution, intelligence, wisdom, charisma, senses, languages, challenge, description, created_at, updated_at, user_id, saving_throws_mask, damage_vulnerabilities_mask, damage_resistances_mask, damage_immunities_mask, cond_immunities_mask, shared)
        VALUES ('#{type}', '#{name}', '#{cite}', '#{size}', '#{monster_type}', '#{alignment}', '#{armor_class}', #{hit_points}, '#{speed}', #{strength}, #{dexterity}, #{constitution}, #{intelligence}, #{wisdom}, #{charisma}, '#{senses}', '#{languages}', #{challenge}, '#{description}', '#{created_at}', '#{updated_at}', #{user_id}, #{saving_throws_mask}, #{damage_vulnerabilities_mask}, #{damage_resistances_mask}, #{damage_immunities_mask}, #{cond_immunities_mask}, '#{shared}')")

      # Traits
      traits = select_all("SELECT * FROM traits WHERE monster_id = #{monster_id}")
      traits.each do |trait|
        trait_id = trait['id']
        update("UPDATE traits SET card_id = #{card_id} WHERE id = #{trait_id}")
      end

      # Actions
      actions = select_all("SELECT * FROM actions WHERE monster_id = #{monster_id}")
      actions.each do |action|
        action_id = action['id']
        update("UPDATE actions SET card_id = #{card_id} WHERE id = #{action_id}")
      end

      # Skills
      skills = select_all("SELECT * FROM monsters_skills WHERE monster_id = #{monster_id}")
      skills.each do |ms|
        ms_monster_id = ms['monster_id']
        skill_id = ms['skill_id']
        value = ms['value']

        insert("INSERT INTO cards_skills (card_id, skill_id, value)
          VALUES (#{card_id}, #{skill_id}, '#{value}')")
      end
    end

    remove_reference :traits, :monster
    remove_reference :actions, :monster
    drop_table :monsters_skills
    drop_table :monsters
  end

  def down
    create_table "monsters", force: :cascade do |t|
      t.string   "name"
      t.string   "cite"
      t.string   "size"
      t.string   "monster_type"
      t.string   "alignment"
      t.string   "armor_class"
      t.integer  "hit_points"
      t.string   "speed"
      t.integer  "strength"
      t.integer  "dexterity"
      t.integer  "constitution"
      t.integer  "intelligence"
      t.integer  "wisdom"
      t.integer  "charisma"
      t.string   "senses"
      t.string   "languages"
      t.float    "challenge",                   default: 0.0,   null: false
      t.text     "description"
      t.datetime "created_at",                                  null: false
      t.datetime "updated_at",                                  null: false
      t.integer  "user_id"
      t.integer  "saving_throws_mask"
      t.integer  "damage_vulnerabilities_mask"
      t.integer  "damage_resistances_mask"
      t.integer  "damage_immunities_mask"
      t.integer  "cond_immunities_mask"
      t.boolean  "shared",                      default: false, null: false
    end

    create_table :monsters_skills, force: :cascase do |t|
      t.integer :value
      t.timestamps
      t.references :monster, index: true, foreign_key: true
      t.references :skill, index: true, foreign_key: true
      t.index [:skill_id, :monster_id], unique: true
    end

    add_reference :traits, :monster, index: true, foreign_key: true
    Trait.reset_column_information

    add_reference :actions, :monster, index: true, foreign_key: true
    Action.reset_column_information

    monsters = select_all("SELECT * FROM cards WHERE type LIKE 'Monster'")
    monsters.each do |monster|
      card_id = monster['id']
      name = monster['name']
      cite = monster['cite']
      size = monster['size']
      monster_type = monster['monster_type']
      alignment = monster['alignment']
      armor_class = monster['armor_class']
      hit_points = monster['hit_points']
      speed = monster['speed']
      strength = monster['strength']
      dexterity = monster['dexterity']
      constitution = monster['constitution']
      intelligence = monster['intelligence']
      wisdom = monster['wisdom']
      charisma = monster['charisma']
      senses = monster['senses']
      languages = monster['languages']
      challenge = monster['challenge']
      description = monster['description']
      created_at = monster['created_at']
      updated_at = monster['updated_at']
      user_id = monster['user_id']
      saving_throws_mask = monster['saving_throws_mask']
      damage_vulnerabilities_mask = monster['damage_vulnerabilities_mask']
      damage_resistances_mask = monster['damage_resistances_mask']
      damage_immunities_mask = monster['damage_immunities_mask']
      cond_immunities_mask = monster['cond_immunities_mask']
      shared = monster['shared']

      monster_id = insert("INSERT INTO monsters (name, cite, size, monster_type, alignment, armor_class, hit_points, speed, strength, dexterity, constitution, intelligence, wisdom, charisma, senses, languages, challenge, description, created_at, updated_at, user_id, saving_throws_mask, damage_vulnerabilities_mask, damage_resistances_mask, damage_immunities_mask, cond_immunities_mask, shared)
        VALUES ('#{name}', '#{cite}', '#{size}', '#{monster_type}', '#{alignment}', '#{armor_class}', #{hit_points}, '#{speed}', #{strength}, #{dexterity}, #{constitution}, #{intelligence}, #{wisdom}, #{charisma}, '#{senses}', '#{languages}', #{challenge}, '#{description}', '#{created_at}', '#{updated_at}', #{user_id}, #{saving_throws_mask}, #{damage_vulnerabilities_mask}, #{damage_resistances_mask}, #{damage_immunities_mask}, #{cond_immunities_mask}, '#{shared}')")

      # Traits
      traits = select_all("SELECT * FROM traits WHERE card_id = #{card_id}")
      traits.each do |trait|
        trait_id = trait['id']
        update("UPDATE traits SET monster_id = #{monster_id} WHERE id = #{trait_id}")
      end

      # Actions
      actions = select_all("SELECT * FROM actions WHERE card_id = #{card_id}")
      actions.each do |action|
        action_id = action['id']
        update("UPDATE actions SET monster_id = #{monster_id} WHERE id = #{action_id}")
      end

      # Skills
      skills = select_all("SELECT * FROM cards_skills WHERE card_id = #{card_id}")
      skills.each do |ms|
        ms_card_id = ms['card_id']
        skill_id = ms['skill_id']
        value = ms['value']

        insert("INSERT INTO monsters_skills (monster_id, skill_id, value)
          VALUES (#{monster_id}, #{skill_id}, '#{value}')")
      end

      delete("DELETE FROM cards WHERE id = #{card_id}")
    end


    change_table :cards do |t|
      t.remove :size, :monster_type, :alignment, :armor_class, :hit_points, :speed, :strength, :dexterity, :constitution, :intelligence, :wisdom, :charisma, :senses, :languages, :challenge, :saving_throws_mask, :damage_vulnerabilities_mask, :damage_resistances_mask, :damage_immunities_mask, :cond_immunities_mask
    end

    remove_reference :traits, :card
    remove_reference :actions, :card
    drop_table :cards_skills
  end
end
