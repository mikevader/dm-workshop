class CreateSpellclasses < ActiveRecord::Migration[5.0]
  def change
    create_table :spellclasses do |t|
      t.integer :spell_id
      t.integer :hero_class_id

      t.timestamps null: false
    end
    add_index :spellclasses, :spell_id
    add_index :spellclasses, :hero_class_id
    add_index :spellclasses, [:spell_id, :hero_class_id], unique: true
  end
end
