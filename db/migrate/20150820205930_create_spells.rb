class CreateSpells < ActiveRecord::Migration
  def change
    create_table :spells do |t|
      t.string :name, index: true
      t.integer :level, index: true
      t.string :school
      t.string :classes
      t.string :casting_time
      t.string :range
      t.string :components
      t.string :duration
      t.text :short_description
      t.text :description
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :spells, [:user_id, :created_at]
  end
end
