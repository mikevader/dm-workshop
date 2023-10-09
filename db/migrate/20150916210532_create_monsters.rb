class CreateMonsters < ActiveRecord::Migration[5.0]
  def change
    create_table :monsters do |t|
      t.string :name
      t.string :cite
      t.string :size
      t.string :monster_type
      t.string :alignment
      t.string :armor_class
      t.integer :hit_points
      t.string :speed
      t.integer :strength
      t.integer :dexterity
      t.integer :constitution
      t.integer :intelligence
      t.integer :wisdom
      t.integer :charisma
      t.string :saving_throws
      t.string :skills
      t.string :damage_vulnerabilities
      t.string :damage_resistances
      t.string :damage_immunities
      t.string :condition_immunities
      t.string :senses
      t.string :languages
      t.integer :challenge
      t.text :description

      t.timestamps null: false
    end
    add_index :monsters, :name
  end
end
