class RemoveCondImmunitiesFromMonsters < ActiveRecord::Migration[5.0]
  def change
    remove_column :monsters, :condition_immunities, :string
  end
end
