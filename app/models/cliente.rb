class Cliente < ApplicationRecord
  # Com a gem pg_search para busca de texto no PostgreSQL
  include PgSearch::Model
  pg_search_scope :search_full_text,
    against: [:descricao],
    using: {
      tsearch: {
        prefix: true,
        any_word: true
      }
    }
end
