class AddCondImmunitiesMaskToMonsters < ActiveRecord::Migration
  def change
    add_column :monsters, :cond_immunities_mask, :integer
  end
end
