class RemoveSavingThrowsFromMonsters < ActiveRecord::Migration[5.0]
  def change
    remove_column :monsters, :saving_throws, :integer
  end
end
