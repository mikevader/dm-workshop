class RemoveBonusFromMonsters < ActiveRecord::Migration
  def change
    remove_column :monsters, :bonus, :integer
    change_column :monsters, :challenge, :float, default: 0.0, null: false
  end
end
