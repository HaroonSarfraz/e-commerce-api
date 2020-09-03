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

ActiveRecord::Schema.define(version: 2020_09_03_130939) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "cards", force: :cascade do |t|
    t.bigint "user_id_id"
    t.string "stripe_id", null: false
    t.string "address_zip", default: ""
    t.string "brand", null: false
    t.string "country", null: false
    t.string "last4", null: false
    t.string "funding", null: false
    t.integer "exp_month", null: false
    t.integer "exp_year", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_cards_on_deleted_at"
    t.index ["user_id_id"], name: "index_cards_on_user_id_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "line_items", force: :cascade do |t|
    t.bigint "order_id_id"
    t.bigint "product_id_id"
    t.integer "cost_cents", default: 0, null: false
    t.string "cost_currency", default: "USD", null: false
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id_id"], name: "index_line_items_on_order_id_id"
    t.index ["product_id_id"], name: "index_line_items_on_product_id_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "state", default: 0, null: false
    t.bigint "user_id_id"
    t.datetime "delivered_at"
    t.bigint "shipping_address_id"
    t.string "stripe_order_id"
    t.bigint "card_id"
    t.integer "total_amount_cents", default: 0, null: false
    t.string "total_amount_currency", default: "USD", null: false
    t.integer "total_items_costs_cents", default: 0, null: false
    t.string "total_items_costs_currency", default: "USD", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_orders_on_card_id"
    t.index ["shipping_address_id"], name: "index_orders_on_shipping_address_id"
    t.index ["state"], name: "index_orders_on_state"
    t.index ["user_id_id"], name: "index_orders_on_user_id_id"
  end

  create_table "products", force: :cascade do |t|
    t.bigint "category_id"
    t.string "name", null: false
    t.text "description"
    t.string "image"
    t.string "stripe_product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["name"], name: "index_products_on_name", unique: true
  end

  create_table "shipping_addresses", force: :cascade do |t|
    t.bigint "user_id"
    t.string "city"
    t.string "country"
    t.string "line1"
    t.string "line2"
    t.string "state"
    t.string "postal_code"
    t.text "note"
    t.boolean "active", default: true, null: false
    t.datetime "deleted_at"
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "phone_no", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_shipping_addresses_on_active"
    t.index ["deleted_at"], name: "index_shipping_addresses_on_deleted_at"
    t.index ["user_id"], name: "index_shipping_addresses_on_user_id"
  end

  create_table "skus", force: :cascade do |t|
    t.bigint "product_id"
    t.integer "inventory", default: 0, null: false
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "USD", null: false
    t.string "stripe_sku_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_skus_on_product_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "nickname"
    t.string "image"
    t.string "email"
    t.json "tokens"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

end
