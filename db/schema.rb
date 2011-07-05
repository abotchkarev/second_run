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

ActiveRecord::Schema.define(:version => 20110705182010) do

  create_table "appointments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "time_factor"
    t.text     "summary"
    t.boolean  "active",      :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "appointments", ["active"], :name => "index_appointments_on_active"
  add_index "appointments", ["project_id"], :name => "index_appointments_on_project_id"
  add_index "appointments", ["user_id"], :name => "index_appointments_on_user_id"

  create_table "projects", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["created_at"], :name => "index_projects_on_created_at"
  add_index "projects", ["user_id"], :name => "index_projects_on_user_id"

  create_table "relationships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["project_id"], :name => "index_relationships_on_project_id"
  add_index "relationships", ["user_id", "project_id"], :name => "index_relationships_on_user_id_and_project_id", :unique => true
  add_index "relationships", ["user_id"], :name => "index_relationships_on_user_id"

  create_table "subordinations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "chief_id"
    t.boolean  "manager"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subordinations", ["chief_id"], :name => "index_subordinations_on_chief_id"
  add_index "subordinations", ["user_id", "chief_id"], :name => "index_subordinations_on_user_id_and_chief_id", :unique => true
  add_index "subordinations", ["user_id"], :name => "index_subordinations_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.boolean  "manager",            :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "admin",              :default => false
    t.integer  "chief_id",           :default => 1
  end

  add_index "users", ["chief_id"], :name => "index_users_on_chief_id"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
