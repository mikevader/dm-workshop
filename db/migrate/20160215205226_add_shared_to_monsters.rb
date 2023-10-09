class AddSharedToMonsters < ActiveRecord::Migration[5.0]
  def change
    add_column :monsters, :shared, :boolean, default: false, null: false
  end
end
