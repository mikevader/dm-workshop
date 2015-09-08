class AddCssclassToItem < ActiveRecord::Migration
  def change
    add_column :items, :cssclass, :string
  end
end
