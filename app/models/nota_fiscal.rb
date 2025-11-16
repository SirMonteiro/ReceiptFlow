class NotaFiscal < ApplicationRecord
  # 1. Apontar o modelo para a tabela 'danfes'
  self.table_name = "danfes"

  # 2. Mapear atributos do XML/antigos para as colunas da tabela 'danfes'
  alias_attribute :access_key,     :chave_acesso
  alias_attribute :emission_date,  :data_saida
  alias_attribute :emitter_name,   :remetente
  alias_attribute :recipient_name, :destinatario
  alias_attribute :total_value,    :valores_totais

  # 3. Associações
  has_many :item_notas,
           class_name: "ItemNota",
           foreign_key: "danfe_id",
           dependent: :destroy

  # Esta é a associação que estava causando o erro de validação
  belongs_to :user

  # 4. Validações
  # 'access_key' funciona por causa do alias
  validates :access_key, presence: true, uniqueness: true
end