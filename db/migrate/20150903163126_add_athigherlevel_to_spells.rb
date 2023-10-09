class AddAthigherlevelToSpells < ActiveRecord::Migration[5.0]
  def change
    add_column :spells, :athigherlevel, :string
  end
end
