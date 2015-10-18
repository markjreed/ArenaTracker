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

ActiveRecord::Schema.define(version: 20151017131756) do

  create_table "match_talent_glyph_selections", force: true do |t|
    t.integer  "Player_id"
    t.integer  "Match_id"
    t.integer  "TalentGlyphSelection_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "match_talent_glyph_selections", ["Match_id"], name: "index_match_talent_glyph_selections_on_Match_id"
  add_index "match_talent_glyph_selections", ["Player_id"], name: "index_match_talent_glyph_selections_on_Player_id"
  add_index "match_talent_glyph_selections", ["TalentGlyphSelection_id"], name: "index_match_talent_glyph_selections_on_TalentGlyphSelection_id"

  create_table "matches", force: true do |t|
    t.string   "date_time"
    t.string   "arena_name"
    t.integer  "winning_faction"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players", force: true do |t|
    t.string   "name"
    t.string   "server_name"
    t.string   "class_name"
    t.string   "spec_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "raw_battles", force: true do |t|
    t.string   "raw_battle_data"
    t.string   "parse_status"
    t.string   "status_message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scores", force: true do |t|
    t.integer  "player_id"
    t.integer  "match_id"
    t.integer  "player_faction"
    t.integer  "killing_blows"
    t.integer  "damage_done"
    t.integer  "healing_done"
    t.integer  "ratings_adjustment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "scores", ["match_id"], name: "index_scores_on_match_id"
  add_index "scores", ["player_id"], name: "index_scores_on_player_id"

  create_table "talent_glyph_selections", force: true do |t|
    t.string   "tal01"
    t.string   "tal02"
    t.string   "tal03"
    t.string   "tal04"
    t.string   "tal05"
    t.string   "tal06"
    t.string   "tal07"
    t.string   "tal08"
    t.string   "gly01"
    t.string   "gly02"
    t.string   "gly03"
    t.string   "gly04"
    t.string   "gly05"
    t.string   "gly06"
    t.string   "gly07"
    t.string   "gly08"
    t.string   "gly09"
    t.string   "gly10"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
