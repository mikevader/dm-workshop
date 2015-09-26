class AddUserReferenceToMonsters < ActiveRecord::Migration
  def change
    add_reference :monsters, :user, index: true, foreign_key: true
  end
end
