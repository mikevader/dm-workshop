class AddImmunitiesMaskToMonsters < ActiveRecord::Migration
  def change
    add_column :monsters, :damage_immunities_mask, :integer
  end
end
