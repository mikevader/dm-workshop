class AddCardSizeToCard < ActiveRecord::Migration[5.0]
  def up
    add_column :cards, :card_size, :string, default: '25x35', null: false

    Monster.all.each do |monster|
      monster.card_size = '35x50'
      monster.save!
    end
  end

  def down
    remove_column :cards, :card_size
  end
end
