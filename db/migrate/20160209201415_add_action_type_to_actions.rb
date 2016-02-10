class AddActionTypeToActions < ActiveRecord::Migration
  def change
    add_column :actions, :action_type, :integer, default: 0, null: false
    add_column :actions, :melee, :boolean
    add_column :actions, :ranged, :boolean
  end
end
