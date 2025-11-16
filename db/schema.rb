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

ActiveRecord::Schema[8.1].define(version: 2025_26_10_230004) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "clientes", force: :cascade do |t|
    t.string "codigo"
    t.datetime "created_at", null: false
    t.string "descricao"
    t.datetime "updated_at", null: false
  end

  create_table "danfes", force: :cascade do |t|
    t.string "cfop", null: false
    t.string "chave_acesso", null: false
    t.string "cliente", null: false
    t.datetime "created_at", null: false
    t.string "cst", null: false
    t.date "data_saida", null: false
    t.text "descricao_produtos", null: false
    t.string "destinatario", null: false
    t.text "impostos", null: false
    t.string "natureza_operacao", null: false
    t.string "ncm", null: false
    t.string "remetente", null: false
    t.string "transportadora", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.decimal "valor", null: false
    t.decimal "valores_totais", null: false
    t.index ["user_id"], name: "index_danfes_on_user_id"
  end

  create_table "despesas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "data"
    t.string "descricao"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.decimal "valor"
    t.index ["user_id"], name: "index_despesas_on_user_id"
  end

  create_table "item_notas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "item_number"
    t.bigint "nota_fiscal_id", null: false
    t.string "product_code"
    t.decimal "quantity", precision: 14, scale: 4
    t.decimal "total_price", precision: 14, scale: 2
    t.decimal "unit_price", precision: 14, scale: 2
    t.datetime "updated_at", null: false
    t.index ["nota_fiscal_id"], name: "index_item_notas_on_nota_fiscal_id"
  end

  create_table "metas_mensais", force: :cascade do |t|
    t.integer "ano"
    t.datetime "created_at", null: false
    t.integer "mes"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.decimal "valor_meta"
    t.index ["user_id", "mes", "ano"], name: "index_metas_mensais_on_user_id_and_mes_and_ano", unique: true
    t.index ["user_id"], name: "index_metas_mensais_on_user_id"
  end

  create_table "month_receipts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nota_fiscais", force: :cascade do |t|
    t.string "access_key"
    t.datetime "created_at", null: false
    t.date "emission_date"
    t.string "emitter_cnpj"
    t.string "emitter_name"
    t.integer "number"
    t.decimal "products_value", precision: 14, scale: 2
    t.string "recipient_cnpj"
    t.string "recipient_name"
    t.integer "series"
    t.decimal "total_value", precision: 14, scale: 2
    t.datetime "updated_at", null: false
    t.index ["access_key"], name: "index_nota_fiscais_on_access_key", unique: true
  end

  create_table "month_receipts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nota_graficos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "data"
    t.string "tipo"
    t.datetime "updated_at", null: false
    t.decimal "valor"
  end

  create_table "orcamento_mensais", force: :cascade do |t|
    t.integer "ano"
    t.datetime "created_at", null: false
    t.integer "mes"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.decimal "valor"
    t.index ["user_id"], name: "index_orcamento_mensais_on_user_id"
  end

  create_table "pedido", force: :cascade do |t|
    t.string "cfop", null: false
    t.string "chave_acesso", null: false
    t.string "cliente", null: false
    t.datetime "created_at", null: false
    t.string "cst", null: false
    t.date "data_saida", null: false
    t.text "descricao_produtos", null: false
    t.string "destinatario", null: false
    t.decimal "impostos", null: false
    t.string "natureza_operacao", null: false
    t.string "ncm", null: false
    t.string "remetente", null: false
    t.string "transportadora", null: false
    t.datetime "updated_at", null: false
    t.decimal "valor", null: false
    t.decimal "valores_totais", null: false
  end

  create_table "pedidos", force: :cascade do |t|
    t.string "chave_acesso"
    t.string "cliente"
    t.datetime "created_at", null: false
    t.text "descricao_produtos"
    t.string "destinatario"
    t.string "natureza_operacao"
    t.string "remetente"
    t.datetime "updated_at", null: false
    t.decimal "valor"
    t.string "valores_totais"
  end

  create_table "uploads", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.binary "file_data", null: false
    t.string "file_name", null: false
    t.string "file_type", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name"
    t.string "nome", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
  end

  create_table "volume_vendas", force: :cascade do |t|
    t.string "cnpj"
    t.datetime "created_at", null: false
    t.date "data_final", null: false
    t.date "data_inicial", null: false
    t.string "loja", null: false
    t.integer "quantidade_notas", default: 0, null: false
    t.decimal "ticket_medio", precision: 15, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.decimal "valor_total", precision: 15, scale: 2, default: "0.0", null: false
    t.index ["loja", "data_inicial", "data_final"], name: "index_volume_vendas_on_store_and_period"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "danfes", "users"
  add_foreign_key "despesas", "users"
  add_foreign_key "item_notas", "nota_fiscais", column: "nota_fiscal_id"
  add_foreign_key "metas_mensais", "users"
  add_foreign_key "orcamento_mensais", "users"
end
