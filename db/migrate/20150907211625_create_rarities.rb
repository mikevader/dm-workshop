class CreateRarities < ActiveRecord::Migration
  def change
    create_table :rarities do |t|
      t.string :name, index: true

      t.timestamps null: false
    end
  end
end
