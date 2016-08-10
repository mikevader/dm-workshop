class AddPositionToTrait < ActiveRecord::Migration[5.0]
  def change
    add_column :traits, :position, :integer
  end
end
