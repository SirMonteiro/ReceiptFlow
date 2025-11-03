require "bigdecimal"

class VolumeVenda < ApplicationRecord
	DEFAULT_LOJA = "Loja não identificada".freeze

	before_validation :preparar_campos

	validates :loja, presence: true
	validates :data_inicial, presence: true
	validates :data_final, presence: true
	validates :valor_total, numericality: { greater_than_or_equal_to: 0, message: "não pode ser negativo" }
	validates :quantidade_notas, numericality: { only_integer: true, greater_than_or_equal_to: 0, message: "não pode ser negativa" }
		validates :ticket_medio, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
	validate :data_final_nao_pode_ser_anterior

	def self.por_periodo(data_inicial:, data_final:, danfes: Danfe.all)
		raise ArgumentError, "Intervalo de datas inválido" if data_final < data_inicial

			relacao = danfes.where(data_saida: data_inicial..data_final)
			relacao.group_by { |danfe| chave_da_loja(danfe) }.map do |_chave, notas|
			loja_nome, loja_cnpj = extrair_identificacao_loja(notas.first)
				total = notas.sum { |nota| BigDecimal(nota.valor.to_s) }
			quantidade = notas.size

			new(
				loja: loja_nome,
				cnpj: loja_cnpj,
				data_inicial: data_inicial,
				data_final: data_final,
				valor_total: total,
					quantidade_notas: quantidade,
					ticket_medio: nil
			).tap(&:valid?)
			end.sort_by { |registro| -registro.valor_total.to_f }
	end

	class << self
		private

		def chave_da_loja(danfe)
			info = danfe.remetente_hash
			nome = info.fetch("razao_social", nil).presence || DEFAULT_LOJA
			cnpj = info.fetch("cnpj", nil).presence
			[nome, cnpj]
		end

		def extrair_identificacao_loja(danfe)
			info = danfe.remetente_hash
			nome = info.fetch("razao_social", nil).presence || DEFAULT_LOJA
			cnpj = info.fetch("cnpj", nil).presence
			[nome, cnpj]
		end
	end

	private

	def data_final_nao_pode_ser_anterior
		return if data_inicial.blank? || data_final.blank?

		errors.add(:data_final, "deve ser posterior ou igual à data inicial") if data_final < data_inicial
	end

	def preparar_campos
				self.valor_total = BigDecimal(valor_total.to_s) if valor_total.present?
				self.valor_total ||= BigDecimal("0")

				self.quantidade_notas = quantidade_notas.to_i if quantidade_notas.present?
				self.quantidade_notas ||= 0

				if ticket_medio.present?
					self.ticket_medio = BigDecimal(ticket_medio.to_s)
					return
				end

				self.ticket_medio = if quantidade_notas.positive?
					(valor_total / quantidade_notas).round(2)
				else
					BigDecimal("0")
				end
	end
end
