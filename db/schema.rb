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

ActiveRecord::Schema.define(version: 20160619152804) do

  create_table "actions", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "action_type", default: 0, null: false
    t.boolean  "melee"
    t.boolean  "ranged"
    t.integer  "card_id"
  end

  add_index "actions", ["card_id"], name: "index_actions_on_card_id"

  create_table "cards", force: :cascade do |t|
    t.string   "name"
    t.string   "icon"
    t.string   "color"
    t.text     "contents"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.integer  "user_id"
    t.string   "badges"
    t.string   "cite"
    t.boolean  "shared",                      default: false, null: false
    t.string   "type"
    t.string   "cssclass"
    t.boolean  "attunement"
    t.text     "description"
    t.integer  "category_id"
    t.integer  "rarity_id"
    t.integer  "level"
    t.string   "school"
    t.string   "casting_time"
    t.string   "range"
    t.string   "components"
    t.string   "duration"
    t.text     "short_description"
    t.string   "picture"
    t.string   "athigherlevel"
    t.boolean  "concentration"
    t.boolean  "ritual",                      default: false
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
    t.string   "senses"
    t.string   "languages"
    t.float    "challenge",                   default: 0.0,   null: false
    t.integer  "saving_throws_mask"
    t.integer  "damage_vulnerabilities_mask"
    t.integer  "damage_resistances_mask"
    t.integer  "damage_immunities_mask"
    t.integer  "cond_immunities_mask"
  end

  add_index "cards", ["category_id"], name: "index_cards_on_category_id"
  add_index "cards", ["name"], name: "index_cards_on_name"
  add_index "cards", ["rarity_id"], name: "index_cards_on_rarity_id"
  add_index "cards", ["user_id"], name: "index_cards_on_user_id"

  create_table "cards_hero_classes", id: false, force: :cascade do |t|
    t.integer "hero_class_id", null: false
    t.integer "card_id",       null: false
  end

  add_index "cards_hero_classes", ["card_id"], name: "index_cards_hero_classes_on_card_id"
  add_index "cards_hero_classes", ["hero_class_id", "card_id"], name: "index_cards_hero_classes_on_hero_class_id_and_card_id", unique: true
  add_index "cards_hero_classes", ["hero_class_id"], name: "index_cards_hero_classes_on_hero_class_id"

  create_table "cards_skills", force: :cascade do |t|
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "card_id"
    t.integer  "skill_id"
  end

  add_index "cards_skills", ["card_id"], name: "index_cards_skills_on_card_id"
  add_index "cards_skills", ["skill_id", "card_id"], name: "index_cards_skills_on_skill_id_and_card_id", unique: true
  add_index "cards_skills", ["skill_id"], name: "index_cards_skills_on_skill_id"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "cssclass"
  end

  add_index "categories", ["name"], name: "index_categories_on_name"

  create_table "filters", force: :cascade do |t|
    t.string   "name"
    t.text     "query"
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "shared",     default: false, null: false
  end

  add_index "filters", ["name"], name: "index_filters_on_name", unique: true
  add_index "filters", ["user_id"], name: "index_filters_on_user_id"

  create_table "hero_classes", force: :cascade do |t|
    t.string   "name"
    t.string   "cssclass"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "hero_classes", ["name"], name: "index_hero_classes_on_name"

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

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true

  create_table "traits", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "card_id"
  end

  add_index "traits", ["card_id"], name: "index_traits_on_card_id"
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
    t.integer  "role",              default: 0,     null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
