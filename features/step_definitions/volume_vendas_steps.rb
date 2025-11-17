# frozen_string_literal: true

require 'bigdecimal'

Given('existem notas fiscais emitidas para as lojas:') do |table|
  raise 'Usuário não autenticado' unless @user

  table.hashes.each_with_index do |row, index|
    valor = BigDecimal(row['valor'].to_s)
    Danfe.create!(
      # --- CORREÇÃO AQUI ---
      number: row['number'], # 1. Adiciona o 'number' da tabela
      # --- FIM DA CORREÇÃO ---

      user: @user,
      cliente: "Cliente #{index + 1}",
      valor: valor,
      chave_acesso: format('%044d', index + 1),
      natureza_operacao: 'Venda',
      remetente: { razao_social: row['loja'], cnpj: row['cnpj'] }.to_json,
      destinatario: { razao_social: "Cliente #{index + 1}" }.to_json,
      descricao_produtos: "Produto #{index + 1}",
      valores_totais: valor,
      impostos: { icms: 18.0, ipi: 5.0 }.to_json,
      cfop: '5102',
      cst: '060',
      ncm: '12345678',
      transportadora: "Transportadora #{index + 1}",
      data_saida: Date.parse(row['data'])
    )
  end
end

When('eu acesso a página de volume de vendas') do
  visit volume_vendas_path
end

When('eu filtro o período de {string} até {string}') do |data_inicial, data_final|
  fill_in 'Data inicial', with: data_inicial
  fill_in 'Data final', with: data_final
  click_button 'Filtrar'
end

Then('devo ver no relatório de volume de vendas a loja {string} com total {string} e notas {string}') do |loja, total, notas|
  within '#volume-vendas' do
    linha = find('tr', text: loja)
    expect(linha).to have_content(total)
    expect(linha).to have_content(notas)
  end
end

Then('devo ver no relatório de volume de vendas o total geral {string}') do |total|
  expect(find('#total-geral')).to have_content(total)
end
