class AddPositionToAction < ActiveRecord::Migration[5.0]
  def change
    add_column :actions, :position, :integer
  end
end
