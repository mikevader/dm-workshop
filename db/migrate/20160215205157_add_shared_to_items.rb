class AddSharedToItems < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :shared, :boolean, default: false, null: false
  end
end
