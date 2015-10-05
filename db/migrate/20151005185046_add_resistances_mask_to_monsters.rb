class AddResistancesMaskToMonsters < ActiveRecord::Migration
  def change
    add_column :monsters, :damage_resistances_mask, :integer
  end
end
