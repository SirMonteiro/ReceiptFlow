class NotaFiscal < ApplicationRecord
  # 1. Apontar o modelo para a tabela 'danfes'
  self.table_name = "danfes"

  # 2. Mapear 'access_key' para 'chave_acesso'
  alias_attribute :access_key, :chave_acesso
  
  # ... (outros aliases que você queira adicionar) ...
  # alias_attribute :emission_date, :data_saida
  # alias_attribute :recipient_name, :destinatario
  # alias_attribute :emitter_name, :remetente
  # alias_attribute :total_value, :valores_totais

  # 3. ATUALIZAR A ASSOCIAÇÃO 'has_many'
  # Agora ela aponta para a nova chave estrangeira 'danfe_id'
  has_many :item_notas,
           class_name: "ItemNota",
           foreign_key: "danfe_id", # <-- MUDANÇA IMPORTANTE
           dependent: :destroy

  # 4. Adicionar a associação 'belongs_to' que já existe na tabela
  belongs_to :user

  # 5. ATUALIZAR AS VALIDAÇÕES
  # A validação 'access_key' funciona por causa do alias
  validates :access_key, presence: true, uniqueness: true
  
  # A validação 'number' foi removida, pois a tabela 'danfes' não a possui.
  # validates :number, presence: true # <-- REMOVIDO
end