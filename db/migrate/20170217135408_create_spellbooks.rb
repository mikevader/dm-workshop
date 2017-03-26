class CreateSpellbooks < ActiveRecord::Migration[5.0]
  def change
    create_table :spellbooks do |t|
      t.string :name
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :spellbooks, :name
  end
end
