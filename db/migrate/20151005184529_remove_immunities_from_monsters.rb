class RemoveImmunitiesFromMonsters < ActiveRecord::Migration[5.0]
  def change
    remove_column :monsters, :damage_immunities, :string
  end
end
