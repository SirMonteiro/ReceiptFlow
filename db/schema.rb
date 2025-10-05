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

ActiveRecord::Schema[7.1].define(version: 2025_10_05_113337) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "pedidos", force: :cascade do |t|
    t.string "cliente", null: false
    t.decimal "valor", precision: 10, scale: 2, null: false
    t.string "chave_acesso"
    t.string "natureza_operacao"
    t.jsonb "remetente"
    t.jsonb "destinatario"
    t.jsonb "descricao_produtos"
    t.decimal "valores_totais", precision: 15, scale: 2
    t.jsonb "impostos"
    t.string "cfop"
    t.string "cst"
    t.string "ncm"
    t.jsonb "transportadora"
    t.datetime "data_saida"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password", null: false
    t.string "role", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
