class AddCssclassToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :cssclass, :string
  end
end
