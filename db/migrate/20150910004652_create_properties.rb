class CreateProperties < ActiveRecord::Migration[5.0]
  def change
    create_table :properties do |t|
      t.string :name
      t.string :value
      t.references :item, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
