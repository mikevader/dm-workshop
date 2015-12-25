class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.string :title
      t.string :description
      t.references :monster, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
