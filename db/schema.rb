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

ActiveRecord::Schema.define(version: 20160518000056) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ip", force: :cascade do |t|
    t.string "address"
  end

  create_table "parameters", force: :cascade do |t|
    t.string "params", array: true
  end

  create_table "payload_requests", force: :cascade do |t|
    t.string   "referred_by"
    t.string   "request_type"
    t.string   "event_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "resolution_id"
    t.integer  "user_agent_id"
    t.integer  "parameters_id"
    t.integer  "ip_id"
    t.integer  "url_id"
  end

  create_table "resolution", force: :cascade do |t|
    t.string "resolution_height"
    t.string "resolution_width"
  end

  create_table "times", force: :cascade do |t|
    t.string "requested_at"
    t.string "responded_in"
  end

  create_table "url_times", force: :cascade do |t|
    t.integer "url_id"
    t.integer "time_id"
  end

  add_index "url_times", ["time_id"], name: "index_url_times_on_time_id", using: :btree
  add_index "url_times", ["url_id"], name: "index_url_times_on_url_id", using: :btree

  create_table "urls", force: :cascade do |t|
    t.string "name"
  end

  create_table "user_agent", force: :cascade do |t|
    t.text "content"
  end

end
