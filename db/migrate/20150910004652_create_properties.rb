class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :name
      t.string :value
      t.references :item, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
