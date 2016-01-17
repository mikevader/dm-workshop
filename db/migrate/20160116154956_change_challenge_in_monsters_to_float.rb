class ChangeChallengeInMonstersToFloat < ActiveRecord::Migration
  def up
    change_column :monsters, :challenge, :float
  end

  def down
    change_column :monsters, :challenge, :integer
  end
end
