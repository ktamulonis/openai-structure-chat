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

ActiveRecord::Schema[7.2].define(version: 2025_11_30_221810) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appchat_functions", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "class_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chats", force: :cascade do |t|
    t.text "context"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "structured_schema_id"
  end

  create_table "function_logs", force: :cascade do |t|
    t.bigint "message_id", null: false
    t.string "name"
    t.text "prompt"
    t.text "results"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id"], name: "index_function_logs_on_message_id"
  end

  create_table "function_parameters", force: :cascade do |t|
    t.bigint "appchat_function_id", null: false
    t.string "name"
    t.string "example_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["appchat_function_id"], name: "index_function_parameters_on_appchat_function_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "chat_id", null: false
    t.text "content"
    t.integer "role"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_messages_on_chat_id"
  end

  create_table "structured_fields", force: :cascade do |t|
    t.bigint "structured_schema_id", null: false
    t.string "key", null: false
    t.string "data_type", default: "string", null: false
    t.boolean "required", default: true, null: false
    t.string "item_type"
    t.text "enum_values"
    t.integer "position"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["structured_schema_id"], name: "index_structured_fields_on_structured_schema_id"
  end

  create_table "structured_schemas", force: :cascade do |t|
    t.string "name", null: false
    t.string "openai_name", null: false
    t.string "model", default: "gpt-5.1", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["openai_name"], name: "index_structured_schemas_on_openai_name", unique: true
  end

  add_foreign_key "function_logs", "messages"
  add_foreign_key "function_parameters", "appchat_functions"
  add_foreign_key "messages", "chats"
  add_foreign_key "structured_fields", "structured_schemas"
end
