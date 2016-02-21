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

ActiveRecord::Schema.define(version: 20160221101532) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.string   "status",              default: "pending",  null: false
    t.string   "game_type",           default: "standard", null: false
    t.integer  "owner_id",                                 null: false
    t.integer  "opponent_id",                              null: false
    t.integer  "current_attacker_id"
    t.integer  "winning_player_id",   default: 0
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "games", ["current_attacker_id"], name: "index_games_on_current_attacker_id", using: :btree
  add_index "games", ["opponent_id"], name: "index_games_on_opponent_id", using: :btree
  add_index "games", ["owner_id"], name: "index_games_on_owner_id", using: :btree
  add_index "games", ["status"], name: "index_games_on_status", using: :btree
  add_index "games", ["winning_player_id"], name: "index_games_on_winning_player_id", using: :btree

  create_table "ships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "user_name",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "users", ["user_name"], name: "index_users_on_user_name", using: :btree

end
