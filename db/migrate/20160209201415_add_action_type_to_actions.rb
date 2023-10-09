class AddActionTypeToActions < ActiveRecord::Migration[5.0]
  def change
    add_column :actions, :action_type, :integer, default: 0, null: false
    add_column :actions, :melee, :boolean
    add_column :actions, :ranged, :boolean
  end
end
