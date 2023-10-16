class CreateRarities < ActiveRecord::Migration[5.0]
  def change
    create_table :rarities do |t|
      t.string :name, index: true

      t.timestamps null: false
    end
  end
end
