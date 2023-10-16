class AddCssclassToItem < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :cssclass, :string
  end
end
