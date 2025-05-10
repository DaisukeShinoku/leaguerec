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

ActiveRecord::Schema[8.0].define(version: 2025_05_10_060726) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "league_statistics", force: :cascade do |t|
    t.bigint "league_id", null: false
    t.bigint "team_id", null: false
    t.integer "matches_played", default: 0
    t.integer "matches_won", default: 0
    t.integer "matches_lost", default: 0
    t.integer "games_won", default: 0
    t.integer "games_lost", default: 0
    t.integer "points", default: 0
    t.integer "rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["league_id", "team_id"], name: "index_league_statistics_on_league_id_and_team_id", unique: true
    t.index ["league_id"], name: "index_league_statistics_on_league_id"
    t.index ["team_id"], name: "index_league_statistics_on_team_id"
  end

  create_table "leagues", force: :cascade do |t|
    t.string "title", null: false
    t.integer "team_count", null: false
    t.integer "match_per_pairing", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "matches", force: :cascade do |t|
    t.bigint "pairing_id", null: false
    t.integer "match_type", default: 0, null: false
    t.integer "match_number", null: false
    t.integer "home_score"
    t.integer "away_score"
    t.boolean "completed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pairing_id"], name: "index_matches_on_pairing_id"
  end

  create_table "pairings", force: :cascade do |t|
    t.bigint "league_id", null: false
    t.bigint "home_team_id", null: false
    t.bigint "away_team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["away_team_id"], name: "index_pairings_on_away_team_id"
    t.index ["home_team_id", "league_id", "away_team_id"], name: "index_pairings_on_home_team_league_away_team", unique: true
    t.index ["home_team_id"], name: "index_pairings_on_home_team_id"
    t.index ["league_id"], name: "index_pairings_on_league_id"
  end

  create_table "player_matches", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.bigint "match_id", null: false
    t.integer "team_side", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_player_matches_on_match_id"
    t.index ["player_id"], name: "index_player_matches_on_player_id"
  end

  create_table "players", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_players_on_team_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.bigint "league_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["league_id"], name: "index_teams_on_league_id"
  end

  add_foreign_key "league_statistics", "leagues"
  add_foreign_key "league_statistics", "teams"
  add_foreign_key "matches", "pairings"
  add_foreign_key "pairings", "leagues"
  add_foreign_key "pairings", "teams", column: "away_team_id"
  add_foreign_key "pairings", "teams", column: "home_team_id"
  add_foreign_key "player_matches", "matches"
  add_foreign_key "player_matches", "players"
  add_foreign_key "players", "teams"
  add_foreign_key "teams", "leagues"
end
