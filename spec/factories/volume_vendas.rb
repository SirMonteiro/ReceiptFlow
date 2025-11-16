# frozen_string_literal: true

FactoryBot.define do
  factory :volume_venda do
    loja { 'Loja Centro' }
    cnpj { '12345678000195' }
    data_inicial { Date.new(2025, 1, 1) }
    data_final { Date.new(2025, 1, 31) }
    valor_total { 2000.0 }
    quantidade_notas { 2 }
    ticket_medio { 1000.0 }
  end
end
