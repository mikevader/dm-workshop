class RenameSizeInCard < ActiveRecord::Migration[5.0]
  def change
    rename_column :cards, :size, :monster_size
  end
end
