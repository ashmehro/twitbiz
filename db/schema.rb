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

ActiveRecord::Schema.define(:version => 20110719132343) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deals", :force => true do |t|
    t.text     "details"
    t.integer  "org_id"
    t.integer  "category_id"
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "is_local"
    t.boolean  "is_state"
    t.boolean  "is_national"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tweet_id"
  end

  create_table "members", :force => true do |t|
    t.string   "name"
    t.string   "twitter_id"
    t.string   "twitter_handle"
    t.string   "full_name"
    t.string   "auth_token"
    t.string   "auth_token_secret"
    t.string   "profile_image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orgs", :force => true do |t|
    t.string   "name"
    t.string   "city"
    t.string   "state"
    t.integer  "zipcode"
    t.string   "address"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "handle"
    t.string   "primary_number"
    t.string   "landline1"
    t.string   "landline2"
    t.string   "cell1"
    t.string   "cell2"
    t.string   "fax"
    t.string   "primary_email"
    t.string   "email2"
    t.string   "facebook_link"
    t.string   "website"
    t.text     "notes"
  end

  create_table "purchases", :force => true do |t|
    t.string   "deal_id"
    t.string   "tweet_id"
    t.string   "user_id"
    t.string   "org_id"
    t.datetime "bought_on"
    t.integer  "count"
    t.text     "details"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tweets", :force => true do |t|
    t.integer  "deal_id"
    t.string   "tweet_id"
    t.string   "screen_name"
    t.string   "real_name"
    t.integer  "level"
    t.boolean  "deal_used"
    t.string   "url"
    t.string   "data"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
