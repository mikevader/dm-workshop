class AddSharedToSpells < ActiveRecord::Migration
  def up
    add_column :spells, :shared, :boolean, default: false, null: false

    # set all existing spells to be shared. At the moment only the official spells are published.
    Spell.reset_column_information
    Spell.update_all(shared: true)
  end

  def down
    remove_column :spells, :shared
  end
end
