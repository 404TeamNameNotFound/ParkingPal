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

ActiveRecord::Schema.define(version: 20151028091422) do

  create_table "lat_lons", force: :cascade do |t|
    t.decimal  "lat",              precision: 15, scale: 10, default: 0.0
    t.decimal  "lon",              precision: 15, scale: 10, default: 0.0
    t.integer  "parking_meter_id"
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
  end

  add_index "lat_lons", ["parking_meter_id"], name: "index_lat_lons_on_parking_meter_id"

  create_table "parking_meters", force: :cascade do |t|
    t.integer  "name"
    t.float    "price"
    t.float    "max_time"
    t.time     "start_time"
    t.time     "end_time"
    t.boolean  "is_broken",   default: false
    t.boolean  "is_occupied", default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "users", force: :cascade do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.string   "address"
    t.text     "description"
    t.string   "titlestring"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
