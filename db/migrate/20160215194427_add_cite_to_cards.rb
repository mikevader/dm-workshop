class AddCiteToCards < ActiveRecord::Migration
  def change
    add_column :cards, :cite, :string
  end
end
