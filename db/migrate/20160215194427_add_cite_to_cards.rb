class AddCiteToCards < ActiveRecord::Migration[5.0]
  def change
    add_column :cards, :cite, :string
  end
end
