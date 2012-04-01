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

ActiveRecord::Schema.define(:version => 20120401100058) do

  create_table "attendees", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "is_admin",   :default => false
  end

  add_index "attendees", ["event_id"], :name => "index_attendees_on_event_id"
  add_index "attendees", ["user_id"], :name => "index_attendees_on_user_id"

  create_table "billing_details", :force => true do |t|
    t.integer  "user_id"
    t.string   "card_type"
    t.string   "card_name"
    t.string   "last_four_digits"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "billing_details", ["user_id"], :name => "index_billing_details_on_user_id"

  create_table "charge_attempts", :force => true do |t|
    t.integer  "billing_detail_id"
    t.boolean  "success"
    t.string   "message"
    t.string   "authorization"
    t.integer  "amount"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "charge_attempts", ["billing_detail_id"], :name => "index_charge_attempts_on_billing_detail_id"

  create_table "devices", :force => true do |t|
    t.string   "guid"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
  end

  create_table "events", :force => true do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.string   "name"
    t.datetime "starts"
    t.datetime "ends"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code"
    t.boolean  "is_public",  :default => true
    t.string   "s3_token"
    t.string   "location"
    t.boolean  "free"
  end

  add_index "events", ["code"], :name => "index_events_on_code", :unique => true

  create_table "inbound_emails", :force => true do |t|
    t.string   "from"
    t.string   "to"
    t.string   "name"
    t.integer  "user_id"
    t.integer  "event_id"
    t.string   "message_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "inbound_emails", ["event_id"], :name => "index_inbound_emails_on_event_id"
  add_index "inbound_emails", ["user_id"], :name => "index_inbound_emails_on_user_id"

  create_table "photos", :force => true do |t|
    t.string   "photo"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "photo_processing", :default => true
    t.string   "creator_type"
    t.integer  "creator_id"
  end

  create_table "signups", :force => true do |t|
    t.datetime "event_date"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
