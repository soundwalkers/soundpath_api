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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121027185507) do

  create_table "bands", :force => true do |t|
    t.string  "name"
    t.string  "page_id"
    t.string  "plays"
    t.string  "listeners"
    t.string  "pic_url"
    t.integer "fan_count"
    t.string  "lastfm_url"
    t.string  "mbid"
  end

  create_table "user_bands", :force => true do |t|
    t.integer "user_id"
    t.integer "band_id"
  end

  create_table "users", :force => true do |t|
    t.string  "name"
    t.integer "facebook_id"
  end

end
