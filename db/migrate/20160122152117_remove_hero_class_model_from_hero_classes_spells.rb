class RemoveHeroClassModelFromHeroClassesSpells < ActiveRecord::Migration[5.0]
  def up
    change_table :hero_classes_spells, id: false do |t|
      t.remove :updated_at
      t.remove :created_at
    end
    remove_column :hero_classes_spells, :id, :primary_key
  end

  def down
    change_table :hero_classes_spells, id: true do |t|

    end
    add_column :hero_classes_spells, :updated_at, :datetime, null: false, default: Time.now
    add_column :hero_classes_spells, :created_at, :datetime, null: false, default: Time.now
    add_column :hero_classes_spells, :id, :primary_key
  end
end
