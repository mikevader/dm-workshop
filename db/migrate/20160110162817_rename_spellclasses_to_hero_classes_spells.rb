class RenameSpellclassesToHeroClassesSpells < ActiveRecord::Migration
  def change
    rename_table :spellclasses, :hero_classes_spells
  end
end
