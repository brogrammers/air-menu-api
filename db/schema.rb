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

ActiveRecord::Schema.define(:version => 20140414190450) do

  create_table "addresses", :force => true do |t|
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "county"
    t.string   "state"
    t.string   "country"
    t.integer  "contactable_id"
    t.string   "contactable_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "website"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "devices", :force => true do |t|
    t.string   "name"
    t.string   "uuid"
    t.string   "token"
    t.string   "platform"
    t.integer  "notifiable_id"
    t.string   "notifiable_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "groups", :force => true do |t|
    t.string  "name"
    t.integer "restaurant_id"
    t.integer "device_id"
  end

  create_table "identities", :force => true do |t|
    t.string   "username"
    t.string   "password"
    t.string   "salt"
    t.string   "email"
    t.boolean  "admin"
    t.boolean  "developer"
    t.integer  "identifiable_id"
    t.string   "identifiable_type"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "locations", :force => true do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "findable_id"
    t.string   "findable_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "menu_items", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.float    "price"
    t.string   "currency"
    t.integer  "menu_section_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "menu_sections", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "menu_id"
    t.integer  "staff_kind_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "menus", :force => true do |t|
    t.string   "name"
    t.integer  "restaurant_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "notifications", :force => true do |t|
    t.string   "content"
    t.boolean  "read"
    t.integer  "remindable_id"
    t.integer  "remindable_type"
    t.string   "payload"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "oauth_access_grants", :force => true do |t|
    t.integer  "resource_owner_id",                 :null => false
    t.integer  "application_id",                    :null => false
    t.string   "token",                             :null => false
    t.integer  "expires_in",                        :null => false
    t.string   "redirect_uri",      :limit => 2048, :null => false
    t.datetime "created_at",                        :null => false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], :name => "index_oauth_access_grants_on_token", :unique => true

  create_table "oauth_access_tokens", :force => true do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id",    :null => false
    t.string   "token",             :null => false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        :null => false
    t.string   "scopes"
    t.integer  "owner_id"
    t.string   "owner_type"
  end

  add_index "oauth_access_tokens", ["refresh_token"], :name => "index_oauth_access_tokens_on_refresh_token", :unique => true
  add_index "oauth_access_tokens", ["resource_owner_id"], :name => "index_oauth_access_tokens_on_resource_owner_id"
  add_index "oauth_access_tokens", ["token"], :name => "index_oauth_access_tokens_on_token", :unique => true

  create_table "oauth_applications", :force => true do |t|
    t.string   "name",                                            :null => false
    t.string   "uid",                                             :null => false
    t.string   "secret",                                          :null => false
    t.string   "redirect_uri", :limit => 2048,                    :null => false
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.integer  "owner_id"
    t.string   "owner_type"
    t.boolean  "trusted",                      :default => false
  end

  add_index "oauth_applications", ["owner_id", "owner_type"], :name => "index_oauth_applications_on_owner_id_and_owner_type"
  add_index "oauth_applications", ["uid"], :name => "index_oauth_applications_on_uid", :unique => true

  create_table "order_items", :force => true do |t|
    t.string   "comment"
    t.integer  "count"
    t.integer  "order_id"
    t.integer  "menu_item_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "state_cd"
    t.datetime "approved_time"
    t.datetime "declined_time"
    t.datetime "start_prepare_time"
    t.datetime "end_prepare_time"
    t.datetime "served_time"
    t.integer  "staff_member_id"
  end

  create_table "orders", :force => true do |t|
    t.integer  "user_id"
    t.integer  "restaurant_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "state_cd"
    t.datetime "approved_time"
    t.datetime "served_time"
    t.datetime "cancelled_time"
    t.integer  "staff_member_id"
  end

  create_table "restaurants", :force => true do |t|
    t.string   "name"
    t.boolean  "loyalty"
    t.boolean  "remote_order"
    t.float    "conversion_rate"
    t.integer  "company_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "active_menu_id"
  end

  create_table "scopes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "scopes_staff_kinds", :force => true do |t|
    t.integer  "staff_kind_id"
    t.integer  "scope_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "staff_kinds", :force => true do |t|
    t.string   "name"
    t.integer  "restaurant_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.boolean  "accept_orders"
    t.boolean  "accept_order_items"
  end

  create_table "staff_members", :force => true do |t|
    t.string   "name"
    t.integer  "staff_kind_id"
    t.integer  "group_id"
    t.integer  "restaurant_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "device_id"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "phone"
  end

end
