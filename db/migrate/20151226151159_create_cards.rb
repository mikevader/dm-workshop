class CreateCards < ActiveRecord::Migration[5.0]
  def change
    create_table :cards do |t|
      t.string :name
      t.string :icon
      t.string :color
      t.text :contents

      t.timestamps null: false
    end
    add_index :cards, :name
  end
end
