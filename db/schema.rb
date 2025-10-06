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

ActiveRecord::Schema[7.1].define(version: 2025_10_06_130000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "clientes", force: :cascade do |t|
    t.string "codigo"
    t.string "descricao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "despesas", force: :cascade do |t|
    t.decimal "valor"
    t.date "data"
    t.string "descricao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "meta_mensals", force: :cascade do |t|
    t.integer "mes"
    t.decimal "valor_meta"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nota_graficos", force: :cascade do |t|
    t.decimal "valor"
    t.string "tipo"
    t.date "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pedido", force: :cascade do |t|
    t.string "cliente", null: false
    t.decimal "valor", null: false
    t.string "chave_acesso", null: false
    t.string "natureza_operacao", null: false
    t.string "remetente", null: false
    t.string "destinatario", null: false
    t.text "descricao_produtos", null: false
    t.decimal "valores_totais", null: false
    t.decimal "impostos", null: false
    t.string "cfop", null: false
    t.string "cst", null: false
    t.string "ncm", null: false
    t.string "transportadora", null: false
    t.date "data_saida", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "uploads", force: :cascade do |t|
    t.string "file_name", null: false
    t.string "file_type", null: false
    t.binary "file_data", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "nome", null: false
    t.string "password_digest", null: false
    t.string "email", null: false
    t.string "nome", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end

