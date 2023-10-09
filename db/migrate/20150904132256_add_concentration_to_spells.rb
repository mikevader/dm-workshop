class AddConcentrationToSpells < ActiveRecord::Migration[5.0]
  def change
    add_column :spells, :concentration, :boolean
  end
end
