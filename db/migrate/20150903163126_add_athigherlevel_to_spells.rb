class AddAthigherlevelToSpells < ActiveRecord::Migration
  def change
    add_column :spells, :athigherlevel, :string
  end
end
