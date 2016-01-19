class AddRitualToSpells < ActiveRecord::Migration
  def change
    add_column :spells, :ritual, :boolean, default: false
  end
end
