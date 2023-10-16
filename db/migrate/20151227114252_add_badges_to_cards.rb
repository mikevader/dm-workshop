class AddBadgesToCards < ActiveRecord::Migration[5.0]
  def change
    add_column :cards, :badges, :string
  end
end
