class RemoveSkillsFromMonsters < ActiveRecord::Migration
  def change
    remove_column :monsters, :skills, :string
  end
end
