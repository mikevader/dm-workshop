class AddCondImmunitiesMaskToMonsters < ActiveRecord::Migration[5.0]
  def change
    add_column :monsters, :cond_immunities_mask, :integer
  end
end
