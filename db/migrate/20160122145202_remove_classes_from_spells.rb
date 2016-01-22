class RemoveClassesFromSpells < ActiveRecord::Migration
  def change
    remove_column :spells, :classes, :string
  end
end
