class CreateJoinTableSpellsSpellbooks < ActiveRecord::Migration[5.0]
  def change
    create_join_table :spells, :spellbooks do |t|
      # t.index [:spell_id, :spellbook_id]
      # t.index [:spellbook_id, :spell_id]
    end
  end
end
