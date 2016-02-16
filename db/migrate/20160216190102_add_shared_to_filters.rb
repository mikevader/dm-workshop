class AddSharedToFilters < ActiveRecord::Migration
  def change
    add_column :filters, :shared, :boolean, default: false, null: false
  end
end
