class RenameSpellclassesToHeroClassesSpells < ActiveRecord::Migration[5.0]
  def change
    rename_table :spellclasses, :hero_classes_spells
  end
end
