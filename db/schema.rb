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

ActiveRecord::Schema.define(version: 20140922063315) do

  create_table "accesses", force: true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accesses", ["project_id"], name: "index_accesses_on_project_id"
  add_index "accesses", ["user_id"], name: "index_accesses_on_user_id"

  create_table "comments", force: true do |t|
    t.string   "key",        null: false
    t.integer  "user_id"
    t.integer  "todo_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["key"], name: "index_comments_on_key", unique: true
  add_index "comments", ["todo_id"], name: "index_comments_on_todo_id"
  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "events", force: true do |t|
    t.string   "kind"
    t.integer  "source_id"
    t.string   "target"
    t.integer  "target_id"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["source_id"], name: "index_events_on_source_id"
  add_index "events", ["target", "target_id"], name: "index_events_on_target_and_target_id"

  create_table "projects", force: true do |t|
    t.string   "key",        null: false
    t.string   "title",      null: false
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["key"], name: "index_projects_on_key", unique: true
  add_index "projects", ["team_id"], name: "index_projects_on_team_id"

  create_table "teams", force: true do |t|
    t.string   "key",        null: false
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teams", ["key"], name: "index_teams_on_key", unique: true

  create_table "todos", force: true do |t|
    t.string   "key",         null: false
    t.integer  "project_id"
    t.integer  "creator_id"
    t.integer  "owner_id"
    t.text     "content"
    t.datetime "end_at"
    t.datetime "complate_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "todos", ["creator_id"], name: "index_todos_on_creator_id"
  add_index "todos", ["key"], name: "index_todos_on_key", unique: true
  add_index "todos", ["owner_id"], name: "index_todos_on_owner_id"
  add_index "todos", ["project_id"], name: "index_todos_on_project_id"

  create_table "users", force: true do |t|
    t.string   "key",        null: false
    t.integer  "team_id"
    t.string   "name"
    t.string   "email"
    t.text     "avatar"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["key"], name: "index_users_on_key", unique: true
  add_index "users", ["team_id"], name: "index_users_on_team_id"

end
