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

ActiveRecord::Schema.define(version: 20141205065010) do

  create_table "authors", force: true do |t|
    t.string   "full_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authors_books", id: false, force: true do |t|
    t.integer "author_id", null: false
    t.integer "book_id",   null: false
  end

  add_index "authors_books", ["author_id", "book_id"], name: "index_authors_books_on_author_id_and_book_id"
  add_index "authors_books", ["book_id", "author_id"], name: "index_authors_books_on_book_id_and_author_id"

  create_table "books", force: true do |t|
    t.string   "isbn10"
    t.string   "isbn13"
    t.string   "title"
    t.integer  "publisher_id"
    t.date     "publication_date"
    t.integer  "copies"
    t.integer  "price"
    t.string   "format"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "books_subjects", id: false, force: true do |t|
    t.integer "book_id",    null: false
    t.integer "subject_id", null: false
  end

  add_index "books_subjects", ["book_id", "subject_id"], name: "index_books_subjects_on_book_id_and_subject_id"
  add_index "books_subjects", ["subject_id", "book_id"], name: "index_books_subjects_on_subject_id_and_book_id"

  create_table "customers", force: true do |t|
    t.string   "full_name",   null: false
    t.string   "username",    null: false
    t.string   "password",    null: false
    t.string   "credit_card"
    t.string   "address"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "customers", ["username"], name: "index_customers_on_username", unique: true

  create_table "line_items", force: true do |t|
    t.integer  "order_id"
    t.integer  "quantity"
    t.integer  "book_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "opinion_ratings", force: true do |t|
    t.integer  "customer_id"
    t.integer  "opinion_id"
    t.integer  "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "opinions", force: true do |t|
    t.integer  "book_id"
    t.integer  "customer_id"
    t.integer  "score"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: true do |t|
    t.integer  "customer_id"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "publishers", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subjects", force: true do |t|
    t.string "name"
  end

end
