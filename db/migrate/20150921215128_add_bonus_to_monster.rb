class AddBonusToMonster < ActiveRecord::Migration[5.0]
  def change
    add_column :monsters, :bonus, :integer, default: 0, null: false
  end
end
