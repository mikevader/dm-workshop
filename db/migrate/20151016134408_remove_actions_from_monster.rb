class RemoveActionsFromMonster < ActiveRecord::Migration
  def change
    remove_column :monsters, :actions, :string
  end
end
