class AddSharedToCards < ActiveRecord::Migration[5.0]
  def change
    add_column :cards, :shared, :boolean, default: false, null: false
  end
end
