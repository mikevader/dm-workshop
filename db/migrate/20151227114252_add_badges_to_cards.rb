class AddBadgesToCards < ActiveRecord::Migration
  def change
    add_column :cards, :badges, :string
  end
end
