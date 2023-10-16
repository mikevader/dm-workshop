class AddPictureToSpells < ActiveRecord::Migration[5.0]
  def change
    add_column :spells, :picture, :string
  end
end
