class RemoveIndexFromHeroClassesSpells < ActiveRecord::Migration
  def up
    remove_index :hero_classes_spells, name: "index_hero_classes_spells_on_spell_id_and_hero_class_id"
  end

  def down
    add_index :hero_classes_spells, [:spell_id, :hero_class_id], name: "index_hero_classes_spells_on_spell_id_and_hero_class_id", unique: true
  end
end
