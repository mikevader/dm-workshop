class RemoveClassesFromSpells < ActiveRecord::Migration[5.0]
  def change
    remove_column :spells, :classes, :string
  end
end
