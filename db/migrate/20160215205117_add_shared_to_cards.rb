class AddSharedToCards < ActiveRecord::Migration
  def change
    add_column :cards, :shared, :boolean, default: false, null: false
  end
end
