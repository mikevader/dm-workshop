class AddCiteToItems < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :cite, :string
  end
end
