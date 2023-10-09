class CreateHeroClasses < ActiveRecord::Migration[5.0]
  def change
    create_table :hero_classes do |t|
      t.string :name, index: true
      t.string :cssclass

      t.timestamps null: false
    end
  end
end
