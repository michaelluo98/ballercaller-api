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

ActiveRecord::Schema.define(version: 20170622053934) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "courts", force: :cascade do |t|
    t.string "address"
    t.string "postal_code"
    t.string "unit_num"
    t.string "city"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "direct_messages", force: :cascade do |t|
    t.text "message"
    t.bigint "sender_id"
    t.bigint "recipient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipient_id"], name: "index_direct_messages_on_recipient_id"
    t.index ["sender_id"], name: "index_direct_messages_on_sender_id"
  end

  create_table "favorite_courts", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "court_id"
    t.integer "count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["court_id"], name: "index_favorite_courts_on_court_id"
    t.index ["user_id"], name: "index_favorite_courts_on_user_id"
  end

  create_table "favorite_teammates", force: :cascade do |t|
    t.bigint "user_one_id"
    t.bigint "user_two_id"
    t.integer "count"
    t.integer "is_friend"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_one_id"], name: "index_favorite_teammates_on_user_one_id"
    t.index ["user_two_id"], name: "index_favorite_teammates_on_user_two_id"
  end

  create_table "friends", force: :cascade do |t|
    t.bigint "user_one_id"
    t.bigint "user_two_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_one_id"], name: "index_friends_on_user_one_id"
    t.index ["user_two_id"], name: "index_friends_on_user_two_id"
  end

  create_table "games", force: :cascade do |t|
    t.bigint "game_mod_id"
    t.integer "mode"
    t.datetime "start_time"
    t.text "extra_info"
    t.integer "status"
    t.bigint "court_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["court_id"], name: "index_games_on_court_id"
    t.index ["game_mod_id"], name: "index_games_on_game_mod_id"
  end

  create_table "histories", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_histories_on_team_id"
    t.index ["user_id"], name: "index_histories_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.bigint "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_teams_on_game_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "histories", "teams"
end
