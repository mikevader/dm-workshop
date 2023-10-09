class AddSharedToFilters < ActiveRecord::Migration[5.0]
  def change
    add_column :filters, :shared, :boolean, default: false, null: false
  end
end
