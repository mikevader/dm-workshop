class CreateFilters < ActiveRecord::Migration
  def change
    create_table :filters do |t|
      t.string :name
      t.text :query
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :filters, :name, unique: true
  end
end
