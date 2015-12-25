class AddCiteToItems < ActiveRecord::Migration
  def change
    add_column :items, :cite, :string
  end
end
