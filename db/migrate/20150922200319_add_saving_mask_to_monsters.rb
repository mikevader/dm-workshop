class AddSavingMaskToMonsters < ActiveRecord::Migration[5.0]
  def change
    add_column :monsters, :saving_throws_mask, :integer
  end
end
