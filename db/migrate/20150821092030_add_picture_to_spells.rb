class AddPictureToSpells < ActiveRecord::Migration
  def change
    add_column :spells, :picture, :string
  end
end
