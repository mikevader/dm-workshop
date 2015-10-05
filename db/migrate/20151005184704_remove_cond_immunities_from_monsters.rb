class RemoveCondImmunitiesFromMonsters < ActiveRecord::Migration
  def change
    remove_column :monsters, :condition_immunities, :string
  end
end
