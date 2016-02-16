class AddSharedToItems < ActiveRecord::Migration
  def change
    add_column :items, :shared, :boolean, default: false, null: false
  end
end
