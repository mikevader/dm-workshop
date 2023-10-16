class AddRoleToUsers < ActiveRecord::Migration[5.0]
  def up
    add_column :users, :role, :integer, default: 0, null: false

    User.all.each do |user|
      user.player!
    end
  end

  def down
    remove_column :users, :role
  end

end
