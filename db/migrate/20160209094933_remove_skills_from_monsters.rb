class RemoveSkillsFromMonsters < ActiveRecord::Migration[5.0]
  def change
    remove_column :monsters, :skills, :string
  end
end
