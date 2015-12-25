class AddSavingMaskToMonsters < ActiveRecord::Migration
  def change
    add_column :monsters, :saving_throws_mask, :integer
  end
end
