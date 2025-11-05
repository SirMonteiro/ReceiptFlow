# frozen_string_literal: true

FactoryBot.define do
  factory :danfe do
    association :user
    cliente { 'Cliente Teste' }
    valor { 1000.00 }
    chave_acesso { '12345678901234567890123456789012345678901234' }
    natureza_operacao { 'Venda' }
    remetente { { razao_social: 'Empresa Remetente LTDA', cnpj: '12345678000195', endereco: 'Rua A, 123' }.to_json }
    destinatario do
      { razao_social: 'Cliente Destinatário LTDA', cnpj: '98765432000195', endereco: 'Rua B, 456' }.to_json
    end
    descricao_produtos { 'Produto 1 - Quantidade: 2 - Valor unitário: R$ 500,00' }
    valores_totais { 1000.00 }
    impostos { { icms: 18.0, ipi: 5.0, pis: 16.5, cofins: 76.0 }.to_json }
    cfop { '5102' }
    cst { '060' }
    ncm { '12345678' }
    transportadora { { razao_social: 'Transportadora XYZ', cnpj: '11222333000144' } }
    data_saida { Time.zone.today }

    trait :january_2025 do
      data_saida { Date.new(2025, 1, 15) }
    end

    trait :february_2025 do
      data_saida { Date.new(2025, 2, 20) }
    end

    trait :october_2025 do
      data_saida { Date.new(2025, 10, 10) }
    end

    trait :december_2024 do
      data_saida { Date.new(2024, 12, 25) }
    end

    trait :high_value do
      valor { 5000.00 }
      valores_totais { 5000.00 }
    end

    trait :low_value do
      valor { 100.00 }
      valores_totais { 100.00 }
    end
  end
end
