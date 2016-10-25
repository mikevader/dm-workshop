class AddCardSizeToCard < ActiveRecord::Migration[5.0]
  def change
    add_column :cards, :card_size, :string, default: '25x35', null: false
  end
end
