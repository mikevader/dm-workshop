# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_09_17_104936) do
  create_table "actions", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "action_type", default: 0, null: false
    t.boolean "melee"
    t.boolean "ranged"
    t.integer "card_id"
    t.integer "position"
    t.index ["card_id"], name: "index_actions_on_card_id"
  end

  create_table "cards", force: :cascade do |t|
    t.string "name"
    t.string "icon"
    t.string "color"
    t.text "contents"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "user_id"
    t.string "badges"
    t.string "cite"
    t.boolean "shared", default: false, null: false
    t.string "type"
    t.string "cssclass"
    t.boolean "attunement"
    t.text "description"
    t.integer "category_id"
    t.integer "rarity_id"
    t.integer "level"
    t.string "school"
    t.string "casting_time"
    t.string "range"
    t.string "components"
    t.string "duration"
    t.text "short_description"
    t.string "picture"
    t.string "athigherlevel"
    t.boolean "concentration"
    t.boolean "ritual", default: false
    t.string "monster_size"
    t.string "monster_type"
    t.string "alignment"
    t.string "armor_class"
    t.integer "hit_points"
    t.string "speed"
    t.integer "strength"
    t.integer "dexterity"
    t.integer "constitution"
    t.integer "intelligence"
    t.integer "wisdom"
    t.integer "charisma"
    t.string "senses"
    t.string "languages"
    t.float "challenge", default: 0.0, null: false
    t.integer "saving_throws_mask"
    t.integer "damage_vulnerabilities_mask"
    t.integer "damage_resistances_mask"
    t.integer "damage_immunities_mask"
    t.integer "cond_immunities_mask"
    t.string "card_size"
    t.integer "source_id"
    t.index ["category_id"], name: "index_cards_on_category_id"
    t.index ["name"], name: "index_cards_on_name"
    t.index ["rarity_id"], name: "index_cards_on_rarity_id"
    t.index ["source_id"], name: "index_cards_on_source_id"
    t.index ["user_id"], name: "index_cards_on_user_id"
  end

  create_table "cards_hero_classes", id: false, force: :cascade do |t|
    t.integer "hero_class_id", null: false
    t.integer "card_id", null: false
    t.index ["card_id"], name: "index_cards_hero_classes_on_card_id"
    t.index ["hero_class_id", "card_id"], name: "index_cards_hero_classes_on_hero_class_id_and_card_id", unique: true
    t.index ["hero_class_id"], name: "index_cards_hero_classes_on_hero_class_id"
  end

  create_table "cards_skills", force: :cascade do |t|
    t.integer "value"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "card_id"
    t.integer "skill_id"
    t.index ["card_id"], name: "index_cards_skills_on_card_id"
    t.index ["skill_id", "card_id"], name: "index_cards_skills_on_skill_id_and_card_id", unique: true
    t.index ["skill_id"], name: "index_cards_skills_on_skill_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "cssclass"
    t.index ["name"], name: "index_categories_on_name"
  end

  create_table "filters", force: :cascade do |t|
    t.string "name"
    t.text "query"
    t.integer "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "shared", default: false, null: false
    t.index ["name"], name: "index_filters_on_name", unique: true
    t.index ["user_id"], name: "index_filters_on_user_id"
  end

  create_table "hero_classes", force: :cascade do |t|
    t.string "name"
    t.string "cssclass"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_hero_classes_on_name"
  end

  create_table "properties", force: :cascade do |t|
    t.string "name"
    t.string "value"
    t.integer "item_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "card_id"
    t.integer "position"
    t.index ["card_id"], name: "index_properties_on_card_id"
    t.index ["item_id"], name: "index_properties_on_item_id"
  end

  create_table "rarities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_rarities_on_name"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "skills", force: :cascade do |t|
    t.string "name"
    t.string "ability"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_skills_on_name"
  end

  create_table "sources", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "spellbooks", force: :cascade do |t|
    t.string "name"
    t.integer "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_spellbooks_on_name"
    t.index ["user_id"], name: "index_spellbooks_on_user_id"
  end

  create_table "spellbooks_spells", id: false, force: :cascade do |t|
    t.integer "spell_id", null: false
    t.integer "spellbook_id", null: false
  end

  create_table "taggings", force: :cascade do |t|
    t.integer "tag_id"
    t.integer "taggable_id"
    t.string "taggable_type"
    t.integer "tagger_id"
    t.string "tagger_type"
    t.string "context", limit: 128
    t.datetime "created_at", precision: nil
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "traits", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "card_id"
    t.integer "position"
    t.index ["card_id"], name: "index_traits_on_card_id"
    t.index ["title"], name: "index_traits_on_title"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at", precision: nil
    t.string "reset_digest"
    t.datetime "reset_sent_at", precision: nil
    t.integer "role", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
