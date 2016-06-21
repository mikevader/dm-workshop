class AddItemDetailsToCard < ActiveRecord::Migration
  def change
    add_column :cards, :cssclass, :string
    add_column :cards, :attunement, :boolean
    add_column :cards, :description, :text
    add_reference :cards, :category, index: true, foreign_key: true
    add_reference :cards, :rarity, index: true, foreign_key: true
  end
end
