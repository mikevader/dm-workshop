class AddResistancesMaskToMonsters < ActiveRecord::Migration[5.0]
  def change
    add_column :monsters, :damage_resistances_mask, :integer
  end
end
