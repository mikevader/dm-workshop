class AddUserRefToCards < ActiveRecord::Migration[5.0]
  def change
    add_reference :cards, :user, index: true, foreign_key: true
  end
end
