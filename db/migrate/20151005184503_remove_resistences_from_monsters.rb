class RemoveResistencesFromMonsters < ActiveRecord::Migration[5.0]
  def change
    remove_column :monsters, :damage_resistances, :string
  end
end
