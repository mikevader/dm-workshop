class CreateTraits < ActiveRecord::Migration
  def change
    create_table :traits do |t|
      t.string :title
      t.string :description
      t.references :monster, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :traits, :title
  end
end
