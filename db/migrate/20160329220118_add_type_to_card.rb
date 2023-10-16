class AddTypeToCard < ActiveRecord::Migration[5.0]
  def change
    add_column :cards, :type, :string
  end
end
