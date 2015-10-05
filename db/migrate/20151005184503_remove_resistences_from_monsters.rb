class RemoveResistencesFromMonsters < ActiveRecord::Migration
  def change
    remove_column :monsters, :damage_resistances, :string
  end
end
