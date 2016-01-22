class AddCiteToSpells < ActiveRecord::Migration
  def change
    add_column :spells, :cite, :string
  end
end
