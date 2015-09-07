class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name, index: true
      t.references :category, index: true, foreign_key: true
      t.references :rarity, index: true, foreign_key: true
      t.boolean :attunement
      t.text :description
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
