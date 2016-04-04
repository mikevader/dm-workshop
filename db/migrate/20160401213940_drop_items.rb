class DropItems < ActiveRecord::Migration
  def up

    items = select_all('SELECT * FROM items')
    items.each do |item|
      user_id = item['user_id']
      type = 'Item'
      name = item['name']
      attunement = item['attunement']
      description = item['description']
      cssclass = item['cssclass']
      cite = item['cite']
      shared = item ['shared']
      category_id = item['category_id']
      rarity_id = item['rarity_id']
      created_at = item['created_at']
      updated_at = item['updated_at']

      insert("INSERT INTO cards (user_id, type, name, attunement, description, cssclass, cite, shared, category_id, rarity_id, created_at, updated_at)
        VALUES (#{user_id}, '#{type}', '#{name}', '#{attunement}', '#{description}', '#{cssclass}', '#{cite}', '#{shared}', #{category_id}, #{rarity_id}, '#{created_at}', '#{updated_at}')")

    end

    drop_table :items
  end

  def down
    create_table :items do |t|
      t.string :name
      t.boolean :attunement
      t.text :description
      t.string :cssclass
      t.string :cite
      t.boolean :shared, default: false, null: false
      t.references :user, index: true, foreign_key: true
      t.references :category, index: true, foreign_key: true
      t.references :rarity, index: true, foreign_key: true
      t.timestamps null: false
    end
    Item.reset_column_information

    items = select_all("SELECT * FROM cards WHERE type LIKE 'item'")
    items.each do |item|
      item_id = item['id']
      user_id = item['user_id']
      name = item['name']
      attunement = item['attunement']
      description = item['description']
      cssclass = item['cssclass']
      cite = item['cite']
      shared = item ['shared']
      category_id = item['category_id']
      rarity_id = item['rarity_id']
      created_at = item['created_at']
      updated_at = item['updated_at']

      insert("INSERT INTO items (user_id, name, attunement, description, cssclass, cite, shared, category_id, rarity_id, created_at, updated_at)
        VALUES (#{user_id}, '#{name}', '#{attunement}', '#{description}', '#{cssclass}', '#{cite}', '#{shared}', #{category_id}, #{rarity_id}, '#{created_at}', '#{updated_at}')")

      delete("DELETE FROM cards WHERE id = #{item_id}")
    end
  end
end
