class AddCssclassToCategory < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :cssclass, :string
  end
end
