class CreateSources < ActiveRecord::Migration[5.0]
  def change
    create_table :sources do |t|
      t.string :name

      t.timestamps
    end

    add_reference :cards, :source, foreign_key: true
  end
end
