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

ActiveRecord::Schema.define(version: 20170623023605) do

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

  create_table "directmessages", force: :cascade do |t|
    t.text "message"
    t.bigint "sender_id"
    t.bigint "recipient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipient_id"], name: "index_directmessages_on_recipient_id"
    t.index ["sender_id"], name: "index_directmessages_on_sender_id"
  end

  create_table "favoritecourts", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "court_id"
    t.integer "count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["court_id"], name: "index_favoritecourts_on_court_id"
    t.index ["user_id"], name: "index_favoritecourts_on_user_id"
  end

  create_table "favoriteteammates", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "teammate_id"
    t.integer "interactions"
    t.boolean "is_friend"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["teammate_id"], name: "index_favoriteteammates_on_teammate_id"
    t.index ["user_id"], name: "index_favoriteteammates_on_user_id"
  end

  create_table "friendships", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "teammate_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["teammate_id"], name: "index_friendships_on_teammate_id"
    t.index ["user_id"], name: "index_friendships_on_user_id"
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
    t.string "api_key"
  end

  add_foreign_key "favoriteteammates", "users"
  add_foreign_key "friendships", "users"
end
