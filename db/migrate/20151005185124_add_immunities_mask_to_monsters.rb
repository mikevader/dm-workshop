class AddImmunitiesMaskToMonsters < ActiveRecord::Migration[5.0]
  def change
    add_column :monsters, :damage_immunities_mask, :integer
  end
end
