class AddCiteToSpells < ActiveRecord::Migration[5.0]
  def change
    add_column :spells, :cite, :string
  end
end
