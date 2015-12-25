class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.string :name
      t.string :ability

      t.timestamps null: false
    end
    add_index :skills, :name
  end
end
