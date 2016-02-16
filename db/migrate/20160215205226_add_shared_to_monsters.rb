class AddSharedToMonsters < ActiveRecord::Migration
  def change
    add_column :monsters, :shared, :boolean, default: false, null: false
  end
end
