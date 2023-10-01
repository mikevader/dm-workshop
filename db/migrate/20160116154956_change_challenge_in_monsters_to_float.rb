class ChangeChallengeInMonstersToFloat < ActiveRecord::Migration[5.0]
  def up
    change_column :monsters, :challenge, :float
  end

  def down
    change_column :monsters, :challenge, :integer
  end
end
