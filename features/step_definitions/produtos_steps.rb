# frozen_string_literal: true

# Scenario: Visualizar produtos mais vendidos
Given('que existem danfes com diferentes produtos cadastradas') do
  user = User.create!(
    email: 'teste@produtos.com',
    password: 'senha123',
    password_confirmation: 'senha123'
  )

  # Produto A - Notebook (mais vendido)
  Danfe.create!(
    user: user,
    chave_acesso: '11111111111111111111111111111111111111111111',
    natureza_operacao: 'Venda',
    remetente_razao_social: 'Tech Store',
    remetente_cnpj: '12345678000195',
    remetente_endereco: 'Rua Tech, 100',
    destinatario_razao_social: 'Cliente A',
    destinatario_cnpj: '98765432000195',
    destinatario_endereco: 'Rua A, 200',
    descricao_produtos: 'Notebook Dell Inspiron',
    valores_totais: 3500.00,
    icms: 630.00,
    ipi: 175.00,
    cfop: '5102',
    cst: '060',
    ncm: '84713012',
    transportadora_razao_social: 'TransTech',
    transportadora_cnpj: '11222333000144',
    data_saida: Date.new(2025, 3, 15)
  )

  Danfe.create!(
    user: user,
    chave_acesso: '22222222222222222222222222222222222222222222',
    natureza_operacao: 'Venda',
    remetente_razao_social: 'Tech Store',
    remetente_cnpj: '12345678000195',
    remetente_endereco: 'Rua Tech, 100',
    destinatario_razao_social: 'Cliente B',
    destinatario_cnpj: '98765432000196',
    destinatario_endereco: 'Rua B, 300',
    descricao_produtos: 'Notebook Dell Inspiron',
    valores_totais: 3500.00,
    icms: 630.00,
    ipi: 175.00,
    cfop: '5102',
    cst: '060',
    ncm: '84713012',
    transportadora_razao_social: 'TransTech',
    transportadora_cnpj: '11222333000144',
    data_saida: Date.new(2025, 4, 10)
  )

  # Produto B - Mouse (valor médio)
  Danfe.create!(
    user: user,
    chave_acesso: '33333333333333333333333333333333333333333333',
    natureza_operacao: 'Venda',
    remetente_razao_social: 'Tech Store',
    remetente_cnpj: '12345678000195',
    remetente_endereco: 'Rua Tech, 100',
    destinatario_razao_social: 'Cliente C',
    destinatario_cnpj: '98765432000197',
    destinatario_endereco: 'Rua C, 400',
    descricao_produtos: 'Mouse Logitech MX Master',
    valores_totais: 450.00,
    icms: 81.00,
    ipi: 22.50,
    cfop: '5102',
    cst: '060',
    ncm: '84716060',
    transportadora_razao_social: 'TransTech',
    transportadora_cnpj: '11222333000144',
    data_saida: Date.new(2025, 3, 20)
  )

  # Produto C - Teclado (menor valor)
  Danfe.create!(
    user: user,
    chave_acesso: '44444444444444444444444444444444444444444444',
    natureza_operacao: 'Venda',
    remetente_razao_social: 'Tech Store',
    remetente_cnpj: '12345678000195',
    remetente_endereco: 'Rua Tech, 100',
    destinatario_razao_social: 'Cliente D',
    destinatario_cnpj: '98765432000198',
    destinatario_endereco: 'Rua D, 500',
    descricao_produtos: 'Teclado Mecânico Keychron',
    valores_totais: 350.00,
    icms: 63.00,
    ipi: 17.50,
    cfop: '5102',
    cst: '060',
    ncm: '84716070',
    transportadora_razao_social: 'TransTech',
    transportadora_cnpj: '11222333000144',
    data_saida: Date.new(2025, 4, 5)
  )

  login_as(user, scope: :user)
end

# Scenario: Visualizar produtos agrupados por NCM
Given('que existem danfes com produtos de mesmo NCM') do
  user = User.create!(
    email: 'teste@ncm.com',
    password: 'senha123',
    password_confirmation: 'senha123'
  )

  # Dois produtos com NCM 84713012 (notebooks)
  Danfe.create!(
    user: user,
    chave_acesso: '55555555555555555555555555555555555555555555',
    natureza_operacao: 'Venda',
    remetente_razao_social: 'Tech Store',
    remetente_cnpj: '12345678000195',
    remetente_endereco: 'Rua Tech, 100',
    destinatario_razao_social: 'Cliente E',
    destinatario_cnpj: '98765432000199',
    destinatario_endereco: 'Rua E, 600',
    descricao_produtos: 'Notebook Dell XPS',
    valores_totais: 5000.00,
    icms: 900.00,
    ipi: 250.00,
    cfop: '5102',
    cst: '060',
    ncm: '84713012',
    transportadora_razao_social: 'TransTech',
    transportadora_cnpj: '11222333000144',
    data_saida: Date.new(2025, 5, 1)
  )

  Danfe.create!(
    user: user,
    chave_acesso: '66666666666666666666666666666666666666666666',
    natureza_operacao: 'Venda',
    remetente_razao_social: 'Tech Store',
    remetente_cnpj: '12345678000195',
    remetente_endereco: 'Rua Tech, 100',
    destinatario_razao_social: 'Cliente F',
    destinatario_cnpj: '98765432000200',
    destinatario_endereco: 'Rua F, 700',
    descricao_produtos: 'Notebook Lenovo ThinkPad',
    valores_totais: 4500.00,
    icms: 810.00,
    ipi: 225.00,
    cfop: '5102',
    cst: '060',
    ncm: '84713012',
    transportadora_razao_social: 'TransTech',
    transportadora_cnpj: '11222333000144',
    data_saida: Date.new(2025, 5, 15)
  )

  # Um produto com NCM diferente
  Danfe.create!(
    user: user,
    chave_acesso: '77777777777777777777777777777777777777777777',
    natureza_operacao: 'Venda',
    remetente_razao_social: 'Tech Store',
    remetente_cnpj: '12345678000195',
    remetente_endereco: 'Rua Tech, 100',
    destinatario_razao_social: 'Cliente G',
    destinatario_cnpj: '98765432000201',
    destinatario_endereco: 'Rua G, 800',
    descricao_produtos: 'Monitor LG 27"',
    valores_totais: 1200.00,
    icms: 216.00,
    ipi: 60.00,
    cfop: '5102',
    cst: '060',
    ncm: '85285210',
    transportadora_razao_social: 'TransTech',
    transportadora_cnpj: '11222333000144',
    data_saida: Date.new(2025, 5, 20)
  )

  login_as(user, scope: :user)
end

# Scenario: Filtrar produtos por período
Given('que existem danfes com produtos em diferentes períodos') do
  user = User.create!(
    email: 'teste@periodo.com',
    password: 'senha123',
    password_confirmation: 'senha123'
  )

  # Produtos no período (Q1 e Q2 2025)
  Danfe.create!(
    user: user,
    chave_acesso: '88888888888888888888888888888888888888888888',
    natureza_operacao: 'Venda',
    remetente_razao_social: 'Tech Store',
    remetente_cnpj: '12345678000195',
    remetente_endereco: 'Rua Tech, 100',
    destinatario_razao_social: 'Cliente H',
    destinatario_cnpj: '98765432000202',
    destinatario_endereco: 'Rua H, 900',
    descricao_produtos: 'Webcam Logitech C920',
    valores_totais: 600.00,
    icms: 108.00,
    ipi: 30.00,
    cfop: '5102',
    cst: '060',
    ncm: '85258020',
    transportadora_razao_social: 'TransTech',
    transportadora_cnpj: '11222333000144',
    data_saida: Date.new(2025, 2, 15)
  )

  Danfe.create!(
    user: user,
    chave_acesso: '99999999999999999999999999999999999999999999',
    natureza_operacao: 'Venda',
    remetente_razao_social: 'Tech Store',
    remetente_cnpj: '12345678000195',
    remetente_endereco: 'Rua Tech, 100',
    destinatario_razao_social: 'Cliente I',
    destinatario_cnpj: '98765432000203',
    destinatario_endereco: 'Rua I, 1000',
    descricao_produtos: 'Headset HyperX Cloud',
    valores_totais: 400.00,
    icms: 72.00,
    ipi: 20.00,
    cfop: '5102',
    cst: '060',
    ncm: '85183000',
    transportadora_razao_social: 'TransTech',
    transportadora_cnpj: '11222333000144',
    data_saida: Date.new(2025, 4, 20)
  )

  # Produto fora do período (Q4 2025)
  Danfe.create!(
    user: user,
    chave_acesso: '10101010101010101010101010101010101010101010',
    natureza_operacao: 'Venda',
    remetente_razao_social: 'Tech Store',
    remetente_cnpj: '12345678000195',
    remetente_endereco: 'Rua Tech, 100',
    destinatario_razao_social: 'Cliente J',
    destinatario_cnpj: '98765432000204',
    destinatario_endereco: 'Rua J, 1100',
    descricao_produtos: 'SSD Samsung 1TB',
    valores_totais: 800.00,
    icms: 144.00,
    ipi: 40.00,
    cfop: '5102',
    cst: '060',
    ncm: '84717050',
    transportadora_razao_social: 'TransTech',
    transportadora_cnpj: '11222333000144',
    data_saida: Date.new(2025, 11, 10)
  )

  login_as(user, scope: :user)
end

When('eu acesso a página de estatísticas de produtos') do
  visit produtos_path
end

When('eu seleciono a visualização {string}') do |visualizacao|
  select visualizacao, from: 'visualizacao'
  click_button 'Filtrar'
end

When('eu seleciono o período de produtos de {string} a {string}') do |data_inicio, data_fim|
  fill_in 'data_inicio', with: data_inicio
  fill_in 'data_fim', with: data_fim
  click_button 'Filtrar'
end

When('eu clico no botão {string}') do |texto_botao|
  click_link_or_button texto_botao
end

Then('eu devo ver a lista de produtos ordenados por valor total') do
  expect(page).to have_content('Estatísticas de Produtos')
  
  # Verificar que Notebook aparece primeiro (maior valor: R$ 7.000,00)
  produtos = page.all('table tbody tr td:first-child').map(&:text)
  expect(produtos.first).to include('Notebook Dell Inspiron')
end

Then('eu devo ver o valor total de cada produto') do
  expect(page).to have_content('R$ 7.000,00') # Notebook (2x R$ 3.500,00)
  expect(page).to have_content('R$ 450,00')   # Mouse
  expect(page).to have_content('R$ 350,00')   # Teclado
end

Then('eu devo ver a quantidade de vendas de cada produto') do
  expect(page).to have_content('2') # Notebook vendido 2 vezes
  expect(page).to have_content('1') # Mouse vendido 1 vez
  expect(page).to have_content('1') # Teclado vendido 1 vez
end

Then('eu devo ver os produtos agrupados por código NCM') do
  expect(page).to have_content('84713012') # NCM de notebooks
  expect(page).to have_content('85285210') # NCM de monitor
end

Then('eu devo ver o valor total por NCM') do
  expect(page).to have_content('R$ 9.500,00') # NCM 84713012 (R$ 5.000,00 + R$ 4.500,00)
  expect(page).to have_content('R$ 1.200,00') # NCM 85285210
end

Then('eu devo ver apenas produtos vendidos nesse período') do
  expect(page).to have_content('Webcam Logitech C920')
  expect(page).to have_content('Headset HyperX Cloud')
  expect(page).not_to have_content('SSD Samsung 1TB')
end

Then('eu devo receber um arquivo {string}') do |nome_arquivo|
  expect(page.response_headers['Content-Disposition']).to include(nome_arquivo)
  expect(page.response_headers['Content-Type']).to include('text/csv')
end

Then('o arquivo deve conter os dados de produtos') do
  csv_content = page.body
  expect(csv_content).to include('Produto')
  expect(csv_content).to include('NCM')
  expect(csv_content).to include('Valor Total')
  expect(csv_content).to include('Quantidade')
end

Then('eu devo ver a mensagem {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end
