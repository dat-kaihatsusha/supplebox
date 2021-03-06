# frozen_string_literal: true

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

ActiveRecord::Schema.define(version: 20_190_518_130_406) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'brands', force: :cascade do |t|
    t.string 'name'
    t.text 'content'
    t.string 'picture'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'contacts', force: :cascade do |t|
    t.string 'title'
    t.text 'content'
    t.bigint 'user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'name'
    t.string 'email'
    t.index ['user_id'], name: 'index_contacts_on_user_id'
  end

  create_table 'likes', force: :cascade do |t|
    t.bigint 'user_id'
    t.bigint 'product_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['product_id'], name: 'index_likes_on_product_id'
    t.index %w[user_id product_id], name: 'index_likes_on_user_id_and_product_id', unique: true
    t.index ['user_id'], name: 'index_likes_on_user_id'
  end

  create_table 'posts', force: :cascade do |t|
    t.string 'title'
    t.text 'content'
    t.string 'picture'
    t.float 'rate'
    t.bigint 'user_id'
    t.bigint 'product_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['product_id'], name: 'index_posts_on_product_id'
    t.index ['user_id'], name: 'index_posts_on_user_id'
  end

  create_table 'products', force: :cascade do |t|
    t.string 'title'
    t.text 'url'
    t.string 'image_url'
    t.string 'asin'
    t.string 'price'
    t.string 'brand_amazon_name'
    t.text 'official_url'
    t.string 'brand_id'
    t.string 'category_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'relationships', force: :cascade do |t|
    t.bigint 'user_id'
    t.bigint 'follow_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['follow_id'], name: 'index_relationships_on_follow_id'
    t.index %w[user_id follow_id], name: 'index_relationships_on_user_id_and_follow_id', unique: true
    t.index ['user_id'], name: 'index_relationships_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'name'
    t.string 'email'
    t.string 'password_digest'
    t.string 'nickname'
    t.string 'weight'
    t.string 'height'
    t.string 'gender'
    t.string 'comment'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.boolean 'admin', default: false
    t.string 'picture'
  end

  add_foreign_key 'contacts', 'users'
  add_foreign_key 'likes', 'products'
  add_foreign_key 'likes', 'users'
  add_foreign_key 'posts', 'products'
  add_foreign_key 'posts', 'users'
  add_foreign_key 'relationships', 'users'
  add_foreign_key 'relationships', 'users', column: 'follow_id'
end
