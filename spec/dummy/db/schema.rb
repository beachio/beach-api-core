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

ActiveRecord::Schema.define(version: 20170511080014) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "beach_api_core_assets", force: :cascade do |t|
    t.string   "file_id",           null: false
    t.string   "file_filename"
    t.integer  "file_size"
    t.string   "file_content_type"
    t.string   "entity_type",       null: false
    t.integer  "entity_id",         null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "file_extension"
    t.index ["entity_id", "entity_type"], name: "index_beach_api_core_assets_on_entity_id_and_entity_type", using: :btree
    t.index ["entity_type", "entity_id"], name: "index_beach_api_core_assets_on_entity_type_and_entity_id", using: :btree
    t.index ["file_content_type"], name: "index_beach_api_core_assets_on_file_content_type", using: :btree
  end

  create_table "beach_api_core_assignments", force: :cascade do |t|
    t.integer  "role_id",     null: false
    t.integer  "user_id",     null: false
    t.string   "keeper_type", null: false
    t.integer  "keeper_id",   null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["keeper_type", "keeper_id"], name: "index_beach_api_core_assignments_on_keeper_type_and_keeper_id", using: :btree
    t.index ["role_id", "user_id", "keeper_id", "keeper_type"], name: "index_bac_assignments_on_r_id_and_u_id_and_k_id_and_k_type", unique: true, using: :btree
    t.index ["role_id"], name: "index_beach_api_core_assignments_on_role_id", using: :btree
    t.index ["user_id"], name: "index_beach_api_core_assignments_on_user_id", using: :btree
  end

  create_table "beach_api_core_atoms", force: :cascade do |t|
    t.string   "name"
    t.string   "title"
    t.string   "kind"
    t.integer  "atom_parent_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["atom_parent_id"], name: "index_beach_api_core_atoms_on_atom_parent_id", using: :btree
    t.index ["name"], name: "index_beach_api_core_atoms_on_name", unique: true, using: :btree
  end

  create_table "beach_api_core_capabilities", force: :cascade do |t|
    t.integer  "service_id",     null: false
    t.integer  "application_id", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["application_id"], name: "index_beach_api_core_capabilities_on_application_id", using: :btree
    t.index ["service_id"], name: "index_beach_api_core_capabilities_on_service_id", using: :btree
  end

  create_table "beach_api_core_favourites", force: :cascade do |t|
    t.integer  "user_id",           null: false
    t.string   "favouritable_type", null: false
    t.integer  "favouritable_id",   null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["favouritable_type", "favouritable_id"], name: "indexfavourites_on_favouritable_type_and_favouritable_id", using: :btree
    t.index ["user_id", "favouritable_id", "favouritable_type"], name: "index_favourites_on_user_id_and_f_id_and_f_type", unique: true, using: :btree
    t.index ["user_id"], name: "index_beach_api_core_favourites_on_user_id", using: :btree
  end

  create_table "beach_api_core_instances", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_beach_api_core_instances_on_name", using: :btree
  end

  create_table "beach_api_core_interaction_attributes", force: :cascade do |t|
    t.integer  "interaction_id",              null: false
    t.string   "key",                         null: false
    t.hstore   "values",         default: {}
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["interaction_id", "key"], name: "index_bac_interaction_attributes_on_interaction_id_and_key", unique: true, using: :btree
    t.index ["interaction_id"], name: "index_beach_api_core_interaction_attributes_on_interaction_id", using: :btree
  end

  create_table "beach_api_core_interaction_keepers", force: :cascade do |t|
    t.integer  "interaction_id", null: false
    t.string   "keeper_type",    null: false
    t.integer  "keeper_id",      null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["interaction_id"], name: "index_beach_api_core_interaction_keepers_on_interaction_id", using: :btree
    t.index ["keeper_type", "keeper_id"], name: "index_beach_api_core_interaction_keepers_on_k_type_and_k_id", using: :btree
  end

  create_table "beach_api_core_interactions", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.string   "kind",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_beach_api_core_interactions_on_user_id", using: :btree
  end

  create_table "beach_api_core_invitation_roles", force: :cascade do |t|
    t.integer  "role_id",       null: false
    t.integer  "invitation_id", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["invitation_id"], name: "index_beach_api_core_invitation_roles_on_invitation_id", using: :btree
    t.index ["role_id"], name: "index_beach_api_core_invitation_roles_on_role_id", using: :btree
  end

  create_table "beach_api_core_invitations", force: :cascade do |t|
    t.string   "email"
    t.integer  "user_id",                 null: false
    t.string   "group_type",              null: false
    t.integer  "group_id",                null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "invitee_id"
    t.string   "token",      default: "", null: false
    t.index ["group_type", "group_id"], name: "index_beach_api_core_invitations_on_group_type_and_group_id", using: :btree
    t.index ["invitee_id"], name: "index_beach_api_core_invitations_on_invitee_id", using: :btree
    t.index ["user_id"], name: "index_beach_api_core_invitations_on_user_id", using: :btree
  end

  create_table "beach_api_core_jobs", force: :cascade do |t|
    t.datetime "start_at"
    t.text     "params"
    t.text     "result"
    t.boolean  "done",       default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "every"
    t.datetime "last_run"
  end

  create_table "beach_api_core_memberships", force: :cascade do |t|
    t.string   "member_type", null: false
    t.integer  "member_id",   null: false
    t.string   "group_type",  null: false
    t.integer  "group_id",    null: false
    t.boolean  "owner"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["group_type", "group_id"], name: "index_beach_api_core_memberships_on_group_type_and_group_id", using: :btree
    t.index ["member_type", "member_id"], name: "index_beach_api_core_memberships_on_member_type_and_member_id", using: :btree
  end

  create_table "beach_api_core_organisations", force: :cascade do |t|
    t.string   "name"
    t.integer  "application_id",  null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.hstore   "logo_properties"
    t.index ["application_id"], name: "index_beach_api_core_organisations_on_application_id", using: :btree
  end

  create_table "beach_api_core_permissions", force: :cascade do |t|
    t.integer  "atom_id",                  null: false
    t.string   "keeper_type",              null: false
    t.integer  "keeper_id",                null: false
    t.hstore   "actions",     default: {}
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "actor"
    t.index ["actions"], name: "index_beach_api_core_permissions_on_actions", using: :btree
    t.index ["atom_id", "actor", "keeper_id", "keeper_type"], name: "index_bac_permissions_on_atom_id_and_actor_and_k_id_and_k_type", unique: true, using: :btree
    t.index ["atom_id"], name: "index_beach_api_core_permissions_on_atom_id", using: :btree
    t.index ["keeper_type", "keeper_id"], name: "index_beach_api_core_permissions_on_keeper_type_and_keeper_id", using: :btree
  end

  create_table "beach_api_core_profile_attributes", force: :cascade do |t|
    t.integer  "profile_id",              null: false
    t.integer  "profile_custom_field_id", null: false
    t.string   "value"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["profile_custom_field_id"], name: "index_profile_attributes_on_profile_custom_field_id", using: :btree
    t.index ["profile_id", "profile_custom_field_id"], name: "index_profile_attrs_on_profile_id_and_profile_custom_field_id", unique: true, using: :btree
    t.index ["profile_id"], name: "index_beach_api_core_profile_attributes_on_profile_id", using: :btree
  end

  create_table "beach_api_core_profile_custom_fields", force: :cascade do |t|
    t.string   "name"
    t.string   "title"
    t.integer  "status"
    t.string   "keeper_type", null: false
    t.integer  "keeper_id",   null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["keeper_type", "keeper_id"], name: "index_profile_custom_fields_on_keeper_type_and_keeper_id", using: :btree
  end

  create_table "beach_api_core_profiles", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.date     "birth_date"
    t.integer  "sex"
    t.string   "time_zone"
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_beach_api_core_profiles_on_user_id", using: :btree
  end

  create_table "beach_api_core_project_keepers", force: :cascade do |t|
    t.integer  "project_id",  null: false
    t.string   "keeper_type", null: false
    t.integer  "keeper_id",   null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["keeper_type", "keeper_id"], name: "index_beach_api_core_project_keepers_on_k_type_and_k_id", using: :btree
    t.index ["project_id"], name: "index_beach_api_core_project_keepers_on_project_id", using: :btree
  end

  create_table "beach_api_core_projects", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id",         null: false
    t.integer  "organisation_id", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["organisation_id"], name: "index_beach_api_core_projects_on_organisation_id", using: :btree
    t.index ["user_id"], name: "index_beach_api_core_projects_on_user_id", using: :btree
  end

  create_table "beach_api_core_roles", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_beach_api_core_roles_on_name", using: :btree
  end

  create_table "beach_api_core_service_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "beach_api_core_services", force: :cascade do |t|
    t.string   "title"
    t.string   "name"
    t.text     "description"
    t.integer  "service_category_id", null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["service_category_id"], name: "index_beach_api_core_services_on_service_category_id", using: :btree
  end

  create_table "beach_api_core_settings", force: :cascade do |t|
    t.string   "name",        null: false
    t.string   "value"
    t.string   "keeper_type", null: false
    t.integer  "keeper_id",   null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["keeper_type", "keeper_id"], name: "index_beach_api_core_settings_on_keeper_type_and_keeper_id", using: :btree
    t.index ["name"], name: "index_beach_api_core_settings_on_name", using: :btree
  end

  create_table "beach_api_core_subscription_plans", force: :cascade do |t|
    t.string   "name"
    t.string   "stripe_id"
    t.integer  "amount"
    t.string   "interval"
    t.integer  "interval_count"
    t.integer  "trial_period_days"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "beach_api_core_teams", force: :cascade do |t|
    t.string   "name"
    t.integer  "application_id", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["application_id"], name: "index_beach_api_core_teams_on_application_id", using: :btree
  end

  create_table "beach_api_core_user_preferences", force: :cascade do |t|
    t.integer "user_id",                     null: false
    t.integer "application_id",              null: false
    t.hstore  "preferences",    default: {}
    t.index ["application_id"], name: "index_beach_api_core_user_preferences_on_application_id", using: :btree
    t.index ["user_id"], name: "index_beach_api_core_user_preferences_on_user_id", using: :btree
  end

  create_table "beach_api_core_users", force: :cascade do |t|
    t.string   "email",                null: false
    t.string   "username",             null: false
    t.string   "password_digest"
    t.datetime "confirmed_at"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "status"
    t.string   "reset_password_token"
    t.index ["email"], name: "index_beach_api_core_users_on_email", using: :btree
    t.index ["username"], name: "index_beach_api_core_users_on_username", using: :btree
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",                               null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",                          null: false
    t.string   "scopes"
    t.string   "previous_refresh_token", default: "", null: false
    t.integer  "organisation_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.text     "redirect_uri",              null: false
    t.string   "scopes",       default: "", null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "owner_type"
    t.integer  "owner_id"
    t.index ["owner_type", "owner_id"], name: "index_oauth_applications_on_owner_type_and_owner_id", using: :btree
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree
  end

  create_table "payola_affiliates", force: :cascade do |t|
    t.string   "code"
    t.string   "email"
    t.integer  "percent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payola_coupons", force: :cascade do |t|
    t.string   "code"
    t.integer  "percent_off"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",      default: true
  end

  create_table "payola_sales", force: :cascade do |t|
    t.string   "email",                limit: 191
    t.string   "guid",                 limit: 191
    t.integer  "product_id"
    t.string   "product_type",         limit: 100
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
    t.string   "stripe_id"
    t.string   "stripe_token"
    t.string   "card_last4"
    t.date     "card_expiration"
    t.string   "card_type"
    t.text     "error"
    t.integer  "amount"
    t.integer  "fee_amount"
    t.integer  "coupon_id"
    t.boolean  "opt_in"
    t.integer  "download_count"
    t.integer  "affiliate_id"
    t.text     "customer_address"
    t.text     "business_address"
    t.string   "stripe_customer_id",   limit: 191
    t.string   "currency"
    t.text     "signed_custom_fields"
    t.integer  "owner_id"
    t.string   "owner_type",           limit: 100
    t.index ["coupon_id"], name: "index_payola_sales_on_coupon_id", using: :btree
    t.index ["email"], name: "index_payola_sales_on_email", using: :btree
    t.index ["guid"], name: "index_payola_sales_on_guid", using: :btree
    t.index ["owner_id", "owner_type"], name: "index_payola_sales_on_owner_id_and_owner_type", using: :btree
    t.index ["product_id", "product_type"], name: "index_payola_sales_on_product", using: :btree
    t.index ["stripe_customer_id"], name: "index_payola_sales_on_stripe_customer_id", using: :btree
  end

  create_table "payola_stripe_webhooks", force: :cascade do |t|
    t.string   "stripe_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payola_subscriptions", force: :cascade do |t|
    t.string   "plan_type"
    t.integer  "plan_id"
    t.datetime "start"
    t.string   "status"
    t.string   "owner_type"
    t.integer  "owner_id"
    t.string   "stripe_customer_id"
    t.boolean  "cancel_at_period_end"
    t.datetime "current_period_start"
    t.datetime "current_period_end"
    t.datetime "ended_at"
    t.datetime "trial_start"
    t.datetime "trial_end"
    t.datetime "canceled_at"
    t.integer  "quantity"
    t.string   "stripe_id"
    t.string   "stripe_token"
    t.string   "card_last4"
    t.date     "card_expiration"
    t.string   "card_type"
    t.text     "error"
    t.string   "state"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "currency"
    t.integer  "amount"
    t.string   "guid",                 limit: 191
    t.string   "stripe_status"
    t.integer  "affiliate_id"
    t.string   "coupon"
    t.text     "signed_custom_fields"
    t.text     "customer_address"
    t.text     "business_address"
    t.integer  "setup_fee"
    t.decimal  "tax_percent",                      precision: 4, scale: 2
    t.index ["guid"], name: "index_payola_subscriptions_on_guid", using: :btree
  end

  add_foreign_key "beach_api_core_atoms", "beach_api_core_atoms", column: "atom_parent_id"
  add_foreign_key "beach_api_core_favourites", "beach_api_core_users", column: "user_id"
  add_foreign_key "beach_api_core_interaction_attributes", "beach_api_core_interactions", column: "interaction_id"
  add_foreign_key "beach_api_core_interaction_keepers", "beach_api_core_interactions", column: "interaction_id"
  add_foreign_key "beach_api_core_interactions", "beach_api_core_users", column: "user_id"
  add_foreign_key "beach_api_core_invitations", "beach_api_core_users", column: "invitee_id"
  add_foreign_key "beach_api_core_project_keepers", "beach_api_core_projects", column: "project_id"
  add_foreign_key "beach_api_core_projects", "beach_api_core_organisations", column: "organisation_id"
  add_foreign_key "beach_api_core_projects", "beach_api_core_users", column: "user_id"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
end
