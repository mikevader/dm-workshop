class RemoveSavingThrowsFromMonsters < ActiveRecord::Migration
  def change
    remove_column :monsters, :saving_throws, :integer
  end
end
