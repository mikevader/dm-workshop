class AddRitualToSpells < ActiveRecord::Migration[5.0]
  def change
    add_column :spells, :ritual, :boolean, default: false
  end
end
