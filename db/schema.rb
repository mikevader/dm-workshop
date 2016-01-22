# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160122152117) do

  create_table "actions", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.integer  "monster_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "actions", ["monster_id"], name: "index_actions_on_monster_id"

  create_table "cards", force: :cascade do |t|
    t.string   "name"
    t.string   "icon"
    t.string   "color"
    t.text     "contents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.string   "badges"
  end

  add_index "cards", ["name"], name: "index_cards_on_name"
  add_index "cards", ["user_id"], name: "index_cards_on_user_id"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "cssclass"
  end

  add_index "categories", ["name"], name: "index_categories_on_name"

  create_table "hero_classes", force: :cascade do |t|
    t.string   "name"
    t.string   "cssclass"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "hero_classes", ["name"], name: "index_hero_classes_on_name"

  create_table "hero_classes_spells", id: false, force: :cascade do |t|
    t.integer "spell_id"
    t.integer "hero_class_id"
  end

  add_index "hero_classes_spells", ["hero_class_id"], name: "index_hero_classes_spells_on_hero_class_id"
  add_index "hero_classes_spells", ["spell_id", "hero_class_id"], name: "index_hero_classes_spells_on_spell_id_and_hero_class_id", unique: true
  add_index "hero_classes_spells", ["spell_id"], name: "index_hero_classes_spells_on_spell_id"

  create_table "items", force: :cascade do |t|
    t.string   "name"
    t.integer  "category_id"
    t.integer  "rarity_id"
    t.boolean  "attunement"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "cssclass"
    t.string   "cite"
  end

  add_index "items", ["category_id"], name: "index_items_on_category_id"
  add_index "items", ["name"], name: "index_items_on_name"
  add_index "items", ["rarity_id"], name: "index_items_on_rarity_id"
  add_index "items", ["user_id"], name: "index_items_on_user_id"

  create_table "monsters", force: :cascade do |t|
    t.string   "name"
    t.string   "cite"
    t.string   "size"
    t.string   "monster_type"
    t.string   "alignment"
    t.string   "armor_class"
    t.integer  "hit_points"
    t.string   "speed"
    t.integer  "strength"
    t.integer  "dexterity"
    t.integer  "constitution"
    t.integer  "intelligence"
    t.integer  "wisdom"
    t.integer  "charisma"
    t.string   "skills"
    t.string   "senses"
    t.string   "languages"
    t.float    "challenge"
    t.text     "description"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "user_id"
    t.integer  "bonus",                       default: 0, null: false
    t.integer  "saving_throws_mask"
    t.integer  "damage_vulnerabilities_mask"
    t.integer  "damage_resistances_mask"
    t.integer  "damage_immunities_mask"
    t.integer  "cond_immunities_mask"
  end

  add_index "monsters", ["name"], name: "index_monsters_on_name"
  add_index "monsters", ["user_id"], name: "index_monsters_on_user_id"

  create_table "monsters_skills", id: false, force: :cascade do |t|
    t.integer "monster_id"
    t.integer "skill_id"
  end

  add_index "monsters_skills", ["monster_id", "skill_id"], name: "index_monsters_skills_on_monster_id_and_skill_id", unique: true
  add_index "monsters_skills", ["monster_id"], name: "index_monsters_skills_on_monster_id"
  add_index "monsters_skills", ["skill_id"], name: "index_monsters_skills_on_skill_id"

  create_table "properties", force: :cascade do |t|
    t.string   "name"
    t.string   "value"
    t.integer  "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "properties", ["item_id"], name: "index_properties_on_item_id"

  create_table "rarities", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "rarities", ["name"], name: "index_rarities_on_name"

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at"

  create_table "skills", force: :cascade do |t|
    t.string   "name"
    t.string   "ability"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "skills", ["name"], name: "index_skills_on_name"

  create_table "spells", force: :cascade do |t|
    t.string   "name"
    t.integer  "level"
    t.string   "school"
    t.string   "casting_time"
    t.string   "range"
    t.string   "components"
    t.string   "duration"
    t.text     "short_description"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "picture"
    t.string   "athigherlevel"
    t.boolean  "concentration"
    t.boolean  "ritual",            default: false
    t.string   "cite"
  end

  add_index "spells", ["level"], name: "index_spells_on_level"
  add_index "spells", ["name"], name: "index_spells_on_name"
  add_index "spells", ["user_id", "created_at"], name: "index_spells_on_user_id_and_created_at"
  add_index "spells", ["user_id"], name: "index_spells_on_user_id"

  create_table "traits", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.integer  "monster_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "traits", ["monster_id"], name: "index_traits_on_monster_id"
  add_index "traits", ["title"], name: "index_traits_on_title"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",             default: false
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
