# frozen_string_literal: true

FactoryBot.define do
  factory :pedido do
    chave_acesso { '12345678901234567890123456789012345678901234' }
    natureza_operacao { 'Venda' }
    remetente { { razao_social: 'Empresa X', cnpj: '12345678000199', endereco: 'Rua A, 123' } }
    destinatario { { razao_social: 'Cliente Y', cnpj: '98765432000188', endereco: 'Rua B, 456' } }
    descricao_produtos { [{ nome: 'Produto 1', quantidade: 10, unidade: 'un', valor: 100.0 }] }
    valores_totais { 100.0 }
    impostos { { icms: 18.0, ipi: 5.0 } }
    cfop { '5102' }
    cst { '060' }
    ncm { '12345678' }
    transportadora { { razao_social: 'Transportadora Z', cnpj: '11222333000144' } }
    data_saida { Time.zone.now }
  end
end
