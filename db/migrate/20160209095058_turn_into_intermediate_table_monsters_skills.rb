class TurnIntoIntermediateTableMonstersSkills < ActiveRecord::Migration
  def up
    change_table :monsters_skills do |t|
      t.column(:id, :primary_key)
      t.column(:value, :integer, defaul: nil, null: true)
      t.timestamps null: false, default: Time.now
    end
    
    change_column_default :monsters_skills, :created_at,  nil
    change_column_default :monsters_skills, :updated_at,  nil
  end
  
  def down
    change_table :monsters_skills do |t|
      t.remove(:id)
      t.remove(:value)
      t.remove :updated_at
      t.remove :created_at
    end
  end
end
