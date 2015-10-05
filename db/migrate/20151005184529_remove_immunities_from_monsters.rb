class RemoveImmunitiesFromMonsters < ActiveRecord::Migration
  def change
    remove_column :monsters, :damage_immunities, :string
  end
end
