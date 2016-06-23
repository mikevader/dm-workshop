class DropItems < ActiveRecord::Migration
  def up

    add_reference :properties, :card, index: true, foreign_key: true
    Property.reset_column_information

    items = select_all('SELECT * FROM items')
    items.each do |item|
      item_id = item['id']
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

      card_id = insert("INSERT INTO cards (user_id, type, name, attunement, description, cssclass, cite, shared, category_id, rarity_id, created_at, updated_at)
        VALUES (#{user_id}, '#{type}', #{sani(name)}, #{sani(attunement)}, #{sani(description)}, #{sani(cssclass)}, #{sani(cite)}, #{sani(shared)}, #{category_id}, #{rarity_id}, '#{created_at}', '#{updated_at}')")

      # Properties
      properties = select_all("SELECT * FROM properties WHERE item_id = #{item_id}")
      properties.each do |property|
        property_id = property['id']
        update("UPDATE properties SET card_id = #{card_id} WHERE id = #{property_id}")
      end

    end
    remove_reference :properties, :item
    drop_table :items
  end

  def sani(value)
    return Card.sanitize(value)
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

    add_reference :properties, :item, index: true, foreign_key: true
    Property.reset_column_information


    items = select_all("SELECT * FROM cards WHERE type LIKE 'item'")
    items.each do |item|
      card_id = item['id']
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

      item_id = insert("INSERT INTO items (user_id, name, attunement, description, cssclass, cite, shared, category_id, rarity_id, created_at, updated_at)
        VALUES (#{user_id}, #{sani(name)}, #{sani(attunement)}, #{sani(description)}, #{sani(cssclass)}, #{sani(cite)}, #{sani(shared)}, #{category_id}, #{rarity_id}, '#{created_at}', '#{updated_at}')")

      # Properties
      properties = select_all("SELECT * FROM properties WHERE card_id = #{card_id}")
      properties.each do |property|
        property_id = property['id']
        update("UPDATE properties SET item_id = #{item_id} WHERE id = #{property_id}")
      end

      delete("DELETE FROM cards WHERE id = #{card_id}")
    end

    remove_reference :properties, :card
  end
end
