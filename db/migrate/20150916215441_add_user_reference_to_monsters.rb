class AddUserReferenceToMonsters < ActiveRecord::Migration[5.0]
  def change
    add_reference :monsters, :user, index: true, foreign_key: true
  end
end
