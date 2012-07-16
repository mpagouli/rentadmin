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

ActiveRecord::Schema.define(:version => 20120716162358) do

  create_table "clients", :force => true do |t|
    t.string   "name"
    t.string   "surname"
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "groups", :force => true do |t|
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.string   "group_name"
    t.string   "description", :limit => 1000
  end

  add_index "groups", ["group_name"], :name => "index_groups_on_group_name", :unique => true

  create_table "makes", :force => true do |t|
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "make_name"
    t.string   "description", :limit => 400
  end

  add_index "makes", ["make_name"], :name => "index_makes_on_make_name", :unique => true

  create_table "models", :force => true do |t|
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "make_id"
    t.integer  "model_id"
    t.integer  "group_id"
    t.string   "model_name"
    t.string   "description", :limit => 400
  end

  add_index "models", ["model_name"], :name => "index_models_on_model_name", :unique => true

  create_table "rates", :force => true do |t|
    t.string   "type"
    t.string   "description"
    t.decimal  "price"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "reservation_vehicles", :force => true do |t|
    t.integer  "reservation_id"
    t.integer  "vehicle_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "reservation_vehicles", ["reservation_id", "vehicle_id"], :name => "index_reservation_vehicles_on_reservation_id_and_vehicle_id", :unique => true

  create_table "reservations", :force => true do |t|
    t.datetime "startDate"
    t.datetime "endDate"
    t.decimal  "duration"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           :default => false
  end

  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

  create_table "vehicles", :force => true do |t|
    t.string   "reg_no"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "model_id"
  end

  add_index "vehicles", ["reg_no"], :name => "index_vehicles_on_reg_no", :unique => true

end
