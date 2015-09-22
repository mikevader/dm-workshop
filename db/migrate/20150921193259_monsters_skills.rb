class MonstersSkills < ActiveRecord::Migration
  def change
    create_table :monsters_skills, id: false do |t|
      t.integer :monster_id
      t.integer :skill_id
    end
    
    add_index :monsters_skills, :monster_id
    add_index :monsters_skills, :skill_id
    add_index :monsters_skills, [:monster_id, :skill_id], unique: true
  end
end
